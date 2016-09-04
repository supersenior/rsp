require 'rails_helper'

RSpec.describe DynamicAttribute, :type => :model do
  describe "#value_class" do
    it "returns the DynamicValue class" do
      da = create(:dynamic_attribute, value_type: 'DynamicValueString')
      expect(da.value_class).to eq(DynamicValueString)
    end
  end

  context '#export_configuration' do
    it 'currency should be integer with custom mask' do
      da = create(:dynamic_attribute, value_type: 'DynamicValueString', export_configuration: {format: :currency})
      expect(da.export_configuration.options[:format]).to eql(:integer)
    end

    it 'should return all export styles' do
      da = create(:dynamic_attribute, value_type: 'DynamicValueString', export_configuration: {format: :currency})
      expect(da.export_styles[:format_code].present?).to be_truthy
    end
  end
end
