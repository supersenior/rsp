class ProductClass < ActiveRecord::Base
  include DistillableAttributes

  belongs_to :product
  has_many :dynamic_values, as: :parent, dependent: :destroy

  serialize :selectors, Hash
  delegate :product_type, :document, :user, :unit_rate_denominator, to: :product

  before_validation :set_class_number, on: :create, unless: :class_number?
  after_create :copy_values_from_previous_class

  def rates
    dynamic_values.joins(:dynamic_attribute).where(dynamic_attributes: {is_rate: true})
  end

  def unit_rate
    return @unit_rate if defined? @unit_rate
    @unit_rate = begin
      if product.contributory
        nil
      else
        _rates = rates # Create a local variable as to not keep reloading rates
        atp_rate = _rates.detect { |r| r.is_atp_rate && r.rate_value }.try(:rate_value)
        return atp_rate if atp_rate

        rate_values = _rates.map(&:rate_value)
        rate_values.blank? || rate_values.any?(&:nil?) ? nil : rate_values.sum
      end
    end
  end

  def description_attribute
    @desc_attribute ||= product_type.dynamic_attributes.where(display_name: 'Class Description').first
  end

  def monthly_premium(volume)
    return nil if volume.nil?
    base_rate = unit_rate && unit_rate_denominator ? unit_rate / unit_rate_denominator : nil
    base_rate.try(:*, volume)
  end

  # Rate guarantee is just the dynamic value with the attribute "Rate Guarantee"
  # TODO: make this not dependant on string comparing the name
  def rate_guarantee
    if dynamic_values.loaded?
      dynamic_values.joins(:dynamic_attribute).where(dynamic_attributes: {display_name: "Rate Guarantee"}).first.try(:value)
    else
      (dynamic_values.detect { |dv| dv.dynamic_attribute.display_name == "Rate Guarantee"}).try(:value)
    end
  end

  def create_values_for_attributes
    product_type.dynamic_attributes.each do |attr|
      attr.value_type.constantize.find_or_create_by! dynamic_attribute_id: attr.id, parent_id: self.id, parent_type: self.class.to_s
    end
  end

  private
  def set_class_number
    self.class_number = (product.product_classes.maximum(:class_number) || 0) + 1
  end

  def copy_values_from_previous_class
    previous = product.product_classes.includes(:dynamic_values).where("class_number < ?", class_number).order("class_number DESC").first
    return if previous.nil?

    previous.dynamic_values.group_by(&:type).each do |type, values|
      new_value_attrs = values.map do |dv|
        dv.attributes.merge(id: nil, parent_id: self.id, skip_discrepency_check: true)
      end

      type.constantize.create(new_value_attrs)
    end
  end
end
