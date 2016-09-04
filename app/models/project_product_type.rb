class ProjectProductType < ActiveRecord::Base
  belongs_to :project
  belongs_to :product_type
  has_many :dynamic_values, as: :parent

  validates :product_type_id, uniqueness: { scope: :project_id,
      message: "should only occur once" }

  def commission=(value)
    attribute = DynamicAttribute.find_by display_name: 'Commission'

    dynamic_values.find_or_initialize_by(dynamic_attribute_id: attribute.id, type: 'DynamicValueString')
                  .update(value: value)
  end

  def rate=(value)
    attribute = DynamicAttribute.find_by display_name: 'Rate'

    dynamic_values.find_or_initialize_by(dynamic_attribute_id: attribute.id, type: 'DynamicValueString')
                  .update(value: value)
  end
end
