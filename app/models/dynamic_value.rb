class DynamicValue < ActiveRecord::Base
  attr_accessor :skip_discrepency_check

  enum comparison_flag: [ :not_compared, :equivalent, :worse, :better ]

  belongs_to :dynamic_attribute
  belongs_to :parent, polymorphic: true
  delegate :user, to: :parent
  delegate :is_rate?, to: :dynamic_attribute

  before_save :update_discrepency, unless: proc{|dyn| dyn.skip_discrepency_check || dyn.comparison_flag_changed? }

  DISCREPENCY_LABEL = {
    equivalent: 'neutral',
    better: 'positive',
    worse: 'negative'
  }
  DISCREPENCY_VALUES = DISCREPENCY_LABEL.invert

  def discrepency=(value)
    self.comparison_flag = (DISCREPENCY_VALUES[value] || :not_compared)
  end

  def document
    parent = self.parent

    case parent
    when ::Product
      parent.document
    when ::ProductClass
      parent.product.document
    when ::ProjectProductType
      parent
    when ::NilClass
      nil
    else
      raise "Trying to handle for unknown type #{parent.class}"
    end
  end

  def project
    document.project if document
  end

  def rate_value
    value.extract_float if value.present? && is_rate?
  end

private

  def update_discrepency
    policy = project.try(:policies).try(:first)
    return if policy.nil? || policy == document

    policy_value = dynamic_attribute.dynamic_values.includes(parent: [product: :document]).find{|value| value.document == policy }

    if policy_value.nil? || (value != policy_value.value)
      self.discrepency = 'neutral'
    else
      self.discrepency = nil
    end
  end
end

Dir[File.expand_path('../dynamic_values/*.rb', __FILE__)].each do |dv_path|
  require dv_path
end
