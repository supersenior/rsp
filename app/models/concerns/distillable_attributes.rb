# Adds helper methods for getting / settings values and selectors for attributes.
# attribute arguments is a DynamicAttribute

module DistillableAttributes
  def selector_for_attribute(attribute)
    dynamic_value_for(attribute).try(:selector)
  end

  def display_name_for_attribute(attribute)
    attribute.display_name
  end

  def value_for_attribute(attribute)
    dynamic_value_for(attribute).try(:value)
  end

  def dynamic_value_for(attribute)
    @values ||= Hash.new.tap { |hash| dynamic_values.each { |dv| hash[dv.dynamic_attribute_id] = dv } }
    @values[attribute.try(:id)]
  end
end
