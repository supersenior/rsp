require 'rails_helper'

describe Admin::CategoriesController do
  let(:user) { create(:user, :api) }
  before(:each) do
    allow_any_instance_of(Admin::CategoriesController).to receive(:true_user).and_return(user)
  end

  describe 'POST #create' do
    it 'should create category' do
      expect {
        post :create, category: {name: 'Test Category', category_order: 1}
      }.to change(Category, :count).to(1)
    end
  end

  describe 'PATCH #update' do
    it 'should update category attributes' do
      category = create(:category)
      patch :update, id: category.id, category: {name: 'Test Category', category_order: 2}
      category.reload
      expect(category.name).to eql('Test Category')
      expect(category.category_order).to eql(2)
    end
  end

  describe 'DELETE #destroy' do
    it 'should delete category' do
      category = create(:category)
      expect {
        delete :destroy, id: category.id
      }.to change(Category, :count).from(1).to(0)
    end
  end
end
