class DynamicValueSerializer < ActiveModel::Serializer
  attributes :id, :key, :name, :value, :discrepency, :advanced, :order

  def key
    object.dynamic_attribute.id
  end

  def name
    object.dynamic_attribute.display_name
  end

  def advanced
    !object.dynamic_attribute.required
  end

  def discrepency
    DynamicValue::DISCREPENCY_LABEL[object.comparison_flag.to_sym] || ""
  end

  def order
    object.dynamic_attribute.attribute_order
  end
end
