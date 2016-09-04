require 'rails_helper'

describe Admin::ProductTypesController do
  let(:user) { create(:user, :api) }
  before(:each) do
    allow_any_instance_of(Admin::ProductTypesController).to receive(:true_user).and_return(user)
  end

  describe 'POST #create' do
    it 'should create product type' do
      expect {
        post :create, product_type: {name: 'Test Product Type'}
      }.to change(ProductType, :count).to(1)
    end
  end

  describe 'PATCH #update' do
    it 'should update product_type attributes' do
      product_type = create(:product_type)
      patch :update, id: product_type.id, product_type: {name: 'Test Product Type', unit_rate_denominator: 2.0}
      product_type.reload
      expect(product_type.name).to eql('Test Product Type')
      expect(product_type.unit_rate_denominator).to eql(2.0)
    end
  end

  describe 'DELETE #destroy' do
    it 'should delete product_type' do
      product_type = create(:product_type)
      expect {
        delete :destroy, id: product_type.id
      }.to change(ProductType, :count).from(1).to(0)
    end
  end
end
