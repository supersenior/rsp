require 'rails_helper'

describe ProjectProductType do
  let(:project_product_type) { create(:project_product_type) }

  before do
    create(:dynamic_attribute, :commission)
    create(:dynamic_attribute, :rate)
  end

  context '#commission' do
    it 'should create commission dynamic value' do
      expect {
        project_product_type.commission = 1.5
      }.to change(DynamicValue, :count).by(1)
    end
  end

  context '#rate' do
    it 'should create rate dynamic value' do
      expect {
        project_product_type.rate = 1.5
      }.to change(DynamicValue, :count).by(1)
    end
  end
end