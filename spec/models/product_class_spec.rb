require 'rails_helper'

RSpec.describe ProductClass, :type => :model do

  let(:product) { create(:product) }

  context 'creation' do
    describe "#set_class_number" do
      it "automatically sets the next available class number" do
        pc1 = create(:product_class, class_number: 3)
        pc2 = pc1.product.product_classes.new
        pc2.send(:set_class_number)
        expect(pc2.class_number).to eq(4)
      end

      it "sets class number on create" do
        pc1 = product.product_classes.create
        pc2 = product.product_classes.create
        expect(pc1.class_number).to eq(1)
        expect(pc2.class_number).to eq(2)
      end
    end

    describe "#copy_values_from_previous_class" do
      it "automatically sets values from the previous class" do
        pc = create(:product_class)
        v1 = create(:dynamic_value_string, parent: pc)
        v2 = create(:dynamic_value_string, parent: pc)

        pc2 = create(:product_class, product: pc.product)
        expect(pc2.dynamic_values.count).to eq(2)
        [v1, v2].each do |val|
          expect(
            pc2.dynamic_values.find_by_dynamic_attribute_id(val.dynamic_attribute_id).value
          ).to eq(val.value)
        end
      end

      it "does nothing if there is no previous class" do
        pc = create(:product_class)
        expect {
          pc.send(:copy_values_from_previous_class)
        }.to change{DynamicValue.count}.by(0)
      end
    end
  end

  describe "#unit_rate" do
    context "non-contributory" do
      let(:pc) { create(:product_class, product: create(:product, contributory: false, product_type: create(:product_type))) }

      it "should be the sum of rates" do
        create(:dynamic_value, value: "0.5", parent: pc, dynamic_attribute: create(:dynamic_attribute, is_rate: true))
        create(:dynamic_value, value: "0.7", parent: pc, dynamic_attribute: create(:dynamic_attribute, is_rate: true))
        expect(pc.unit_rate).to eq(1.2)
      end

      it "should use composite values from age bands" do
        create(:dynamic_value_age_band, value: {"composite" => "0.5"}, parent: pc, dynamic_attribute: create(:dynamic_attribute, is_rate: true))
        create(:dynamic_value_age_band, value: {"composite" => "0.7"}, parent: pc, dynamic_attribute: create(:dynamic_attribute, is_rate: true))
        pc.reload
        expect(pc.unit_rate).to eq(1.2)
      end

      it "should return nil if age banded values don't have a composite" do
        create(:dynamic_value_age_band, value: {"composite" => "0.5"}, parent: pc, dynamic_attribute: create(:dynamic_attribute, is_rate: true))
        create(:dynamic_value_age_band, value: {"composite" => nil}, parent: pc, dynamic_attribute: create(:dynamic_attribute, is_rate: true))
        pc.reload
        expect(pc.unit_rate).to eq(nil)
      end

      it "should use the first rate that is an ATP rate (instead of summing)" do
        create(:dynamic_value, value: "0.5", is_atp_rate: true, parent: pc, dynamic_attribute: create(:dynamic_attribute, is_rate: true))
        create(:dynamic_value, value: "0.7", is_atp_rate: false, parent: pc, dynamic_attribute: create(:dynamic_attribute, is_rate: true))
        expect(pc.unit_rate).to eq(0.5)
      end
    end

    context "contributory" do
      it "should be nil" do
        pc = create(:product_class, product: create(:product, contributory: true, product_type: create(:product_type)))
        create(:dynamic_value, value: "0.5", parent: pc, dynamic_attribute: create(:dynamic_attribute, is_rate: true))
        expect(pc.unit_rate).to eq(nil)
      end
    end

    describe "#monthly_premium" do
      it "should be the (unit_rate / denominator) * volume" do
        pc = create(:product_class)
        allow(pc).to receive(:unit_rate) { 100.0 }
        allow(pc).to receive(:unit_rate_denominator) { 5.0 }
        expect(pc.monthly_premium(10.0)).to eq(200.0)
      end

      it "should be nil if unit_rate is nil" do
        pc = create(:product_class)
        allow(pc).to receive(:unit_rate) { nil }
        allow(pc).to receive(:unit_rate_denominator) { 5.0 }
        expect(pc.monthly_premium(10.0)).to eq(nil)
      end

      it "should be nil if unit_rate_denominator is nil" do
        pc = create(:product_class)
        allow(pc).to receive(:unit_rate) { 100.0 }
        allow(pc).to receive(:unit_rate_denominator) { nil }
        expect(pc.monthly_premium(10.0)).to eq(nil)
      end

      it "should be nil if volume is nil" do
        pc = create(:product_class)
        allow(pc).to receive(:unit_rate) { 100.0 }
        allow(pc).to receive(:unit_rate_denominator) { 1.0 }
        expect(pc.monthly_premium(nil)).to eq(nil)
      end
    end
  end

  describe '#description_attribute' do
    it 'should return Class Description attribute' do
      pc = create(:product_class)
      dynamic_attributes = create_list(:dynamic_attribute, 5)
      dynamic_attributes.each { |da| da.product_types << pc.product_type }
      expect(pc.product_type.dynamic_attributes.count).to eql(5)
      expect(pc.description_attribute).to be_nil

      class_attribute = create(:dynamic_attribute, :class_description)
      class_attribute.product_types << pc.product_type
      expect(pc.product_type.dynamic_attributes.count).to eql(6)
      expect(pc.description_attribute).to eql(class_attribute)
    end
  end

  describe '#rate_guarantee' do
    it 'should get Rate Guarantee value' do
      pc = create(:product_class)
      dynamic_values = create_list(:dynamic_value_string, 5, parent: pc)
      expect(pc.rate_guarantee).to be_nil

      rate_guarantee = create(:dynamic_value_string, :rate_guarantee, parent: pc)
      expect(pc.rate_guarantee).to eql(rate_guarantee.value)
    end
  end

  describe '#create'
end
