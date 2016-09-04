require 'rails_helper'

describe Admin::ProductClassesController do
  let(:user) { create(:user, :api) }
  let(:product) { create(:product) }
  let(:product_class) { create(:product_class, product: product) }
  before(:each) do
    allow_any_instance_of(Admin::ProductClassesController).to receive(:true_user).and_return(user)
  end

  describe 'POST #create' do
    it 'should create new product class' do
      expect {
        post :create, {product_id: product.id}
      }.to change(product.product_classes, :count).by(1)
    end

    it 'should create new product class with empty values' do
      dynamic_attributes = create_list(:dynamic_attribute, 5)
      dynamic_attributes.each { |da| da.product_types << product.product_type }

      expect {
        post :create, {product_id: product.id}
      }.to change(product.product_classes, :count).by(1)
      expect(product.product_classes.first.dynamic_values.count).to eql(5)
    end
  end

  describe 'PATCH #update' do
    before do
      @dynamic_attribute = create(:dynamic_attribute)
      @dynamic_attribute.product_types << product.product_type
    end

    it 'should create review record' do
      expect {
        patch :update, product_id: product.id, id: product_class.id, attribute_id: @dynamic_attribute.id, format: :json
      }.to change(Review, :count).by(1)
    end

    it 'should create review item record' do
      expect {
        patch :update, product_id: product.id, id: product_class.id, attribute_id: @dynamic_attribute.id, format: :json
      }.to change(ReviewItem, :count).by(1)
    end

    it 'should create dynamic value' do
      expect {
        patch :update, product_id: product.id, id: product_class.id, attribute_id: @dynamic_attribute.id, attribute_value: 'test', format: :json
      }.to change(DynamicValue, :count).by(1)
    end

    it 'should not create dynamic value if attribute value is not set' do
      expect {
        patch :update, product_id: product.id, id: product_class.id, attribute_id: @dynamic_attribute.id, format: :json
      }.to change(DynamicValue, :count).by(0)
    end

    it 'should not create review record if attribute id is not set' do
      expect {
        patch :update, product_id: product.id, id: product_class.id, format: :json
      }.to change(Review, :count).by(0)
    end

    it 'should update is_atp_rate field' do
      expect {
        patch :update, product_id: product.id, id: product_class.id, attribute_id: @dynamic_attribute.id, column_name: :is_atp_rate, attribute_value: 'true'
      }.to change(DynamicValue, :count).by(1)
      expect(DynamicValue.first.is_atp_rate).to be_truthy
    end
  end

  describe 'DELETE #destroy' do
    it 'should destory product class' do
      product
      product_class
      expect {
        delete :destroy, id: product_class.id
      }.to change(product.product_classes, :count).from(1).to(0)
    end
  end
end
