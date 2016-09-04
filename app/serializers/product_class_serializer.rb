class ProductClassSerializer < ActiveModel::Serializer
  attributes :id, :name, :data, :class_number, :unit_rate_denominator, :unit_rate, :rate_guarantee

  def name
    "Class #{object.class_number}"
  end

  def data
    [].tap do |groups|
      object.dynamic_values.includes(dynamic_attribute: :category).each do |value|
        category = value.dynamic_attribute.category
        group = groups.detect { |g| g[:id] == value.dynamic_attribute.category.id }
        if group.nil?
          group = {id: category.id, name: category.name, order: category.category_order, values: []}
          groups << group
        end
        group[:values] << DynamicValueSerializer.new(value).as_json["dynamic_value"]
      end
    end
  end
end
