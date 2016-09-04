require 'rails_helper'

describe Admin::ProductsController do
  let(:user) { create(:user, :api) }
  before(:each) do
    allow_any_instance_of(Admin::ProductsController).to receive(:true_user).and_return(user)
  end

  describe 'POST #create' do
    it 'should create product' do
      expect {
        post :create, document_id: create(:document).id, product: {contributory: false}
      }.to change(Product, :count).to(1)
    end
  end

  describe 'PATCH #update' do
    it 'should update product attributes' do
      product = create(:product)
      patch :update, id: product.id, product: {contributory: true}
      product.reload
      expect(product.contributory).to be_truthy
    end
  end

  describe 'DELETE #destroy' do
    it 'should delete product' do
      product = create(:product)
      expect {
        delete :destroy, id: product.id
      }.to change(Product, :count).from(1).to(0)
    end
  end
end
