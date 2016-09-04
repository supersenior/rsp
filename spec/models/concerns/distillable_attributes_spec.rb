require 'rails_helper'

describe DistillableAttributes do
  class Philistine < OpenStruct
    include DistillableAttributes

    def read_attribute(attribute)
      marshal_dump[attribute]
    end

    def dynamic_values
      DynamicValue.all
    end
  end

  let (:attribute) { create(:dynamic_attribute) }

  context '#value_for_attribute' do
    it "should return nil if the attribute is not present" do
      philistine = Philistine.new
      val = philistine.value_for_attribute(attribute)
      expect(val).to eq(nil)
    end

    it "should the dynamic values value when present" do
      philistine = Philistine.new
      create(:dynamic_value, value: "12345", dynamic_attribute: attribute)
      val = philistine.value_for_attribute(attribute)
      expect(val).to eq("12345")
    end
  end

  context '#display_name_for_attribute' do
    it 'should return display name of attribute' do
      philistine = Philistine.new
      expect(philistine.display_name_for_attribute(attribute)).to eql(attribute.display_name)
    end
  end

  context '#selector_for_attribute' do
    it 'should return selector of attribute' do
      philistine = Philistine.new
      create(:dynamic_value, dynamic_attribute: attribute, selector: 'Test')
      expect(philistine.selector_for_attribute(attribute)).to eql('Test')
    end
  end
end
