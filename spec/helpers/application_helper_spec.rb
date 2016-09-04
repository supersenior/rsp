require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do

  describe "#attributes_for_display" do
    it "gets the DynamicAttributes for an object based on parent class" do
      a1 = create(:dynamic_attribute, parent_class: "Product")
      a2 = create(:dynamic_attribute, parent_class: "Product")
      a3 = create(:dynamic_attribute, parent_class: "SOME OTHER CLASS")
      returned_attributes = helper.attributes_for_display(create(:product))
      expect(returned_attributes).to eq({"General" => [a1, a2]})
    end

    it "gets the DynamicAttributes for an object based on product type" do
      p1 = create(:product_type)
      p2 = create(:product_type)
      a1 = create(:dynamic_attribute, parent_class: "Product", product_types: [p1, p2])
      a2 = create(:dynamic_attribute, parent_class: "Product", product_types: [p1])
      a3 = create(:dynamic_attribute, parent_class: "Product", product_types: [p2])
      returned_attributes = helper.attributes_for_display(create(:product, product_type: p1))
      expect(returned_attributes).to eq({"General" => [a1, a2]})
    end

    it "should group by category name" do
      c1 = create(:category, name: "cat 5")
      a1 = create(:dynamic_attribute, parent_class: "Product", category: c1)
      a2 = create(:dynamic_attribute, parent_class: "Product", category: c1)
      a3 = create(:dynamic_attribute, parent_class: "Product")
      returned_attributes = helper.attributes_for_display(create(:product))
      expect(returned_attributes).to eq({"cat 5" => [a1, a2], "General" => [a3]})
    end

    it "should sort categories" do
      c1 = create(:category, name: "cat 3", category_order: 3)
      c2 = create(:category, name: "cat 2", category_order: 2)
      c3 = create(:category, name: "cat 5", category_order: 5)
      a1 = create(:dynamic_attribute, parent_class: "Product", category: c1)
      a2 = create(:dynamic_attribute, parent_class: "Product", category: c2)
      a3 = create(:dynamic_attribute, parent_class: "Product", category: c3)
      returned_attributes = helper.attributes_for_display(create(:product))
      expect(returned_attributes.keys).to eq(["cat 2", "cat 3", "cat 5"])
    end

    it "should sort attributes" do
      c1 = create(:category, name: "cat 3")
      a1 = create(:dynamic_attribute, parent_class: "Product", category: c1, attribute_order: 3)
      a2 = create(:dynamic_attribute, parent_class: "Product", category: c1, attribute_order: 2)
      a3 = create(:dynamic_attribute, parent_class: "Product", category: c1, attribute_order: 5)
      returned_attributes = helper.attributes_for_display(create(:product))
      expect(returned_attributes[c1.name]).to eq([a2, a1, a3])
    end
  end

  describe "attributes_for_carrier" do
    before(:each) do
      @carrier = create(:carrier)
    end

    it "should sort attributes using carrier override" do
      c1 = create(:category)
      p = create(:product_type)
      a1 = create(:dynamic_attribute, parent_class: "Product", category: c1, attribute_order: 3, product_types: [p])
      a2 = create(:dynamic_attribute, parent_class: "Product", category: c1, attribute_order: 2, product_types: [p])
      a3 = create(:dynamic_attribute, parent_class: "Product", category: c1, attribute_order: 5, product_types: [p])
      Ordering.create(parent: a3, carrier: @carrier, product_type: p, order_index: 1)
      returned_attributes = helper.attributes_for_carrier(create(:product), @carrier, p)
      expect(returned_attributes).to eq([a3, a2, a1])
    end
  end

  describe "#display_for_age_band" do
    it "displays the format n - n" do
      expect(helper.display_for_age_band(:age_20_24)).to eq("20 - 24")
    end

    it "displays the format n+" do
      expect(helper.display_for_age_band(:age_20_plus)).to eq("20+")
    end
  end
end
