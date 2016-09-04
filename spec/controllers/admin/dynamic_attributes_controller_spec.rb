require 'rails_helper'

describe Admin::DynamicAttributesController do
  let(:user) { create(:user, :api) }
  before(:each) do
    allow_any_instance_of(Admin::DynamicAttributesController).to receive(:true_user).and_return(user)
  end

  describe 'GET #index' do
    it 'should retrieve all dynamic attributes' do
      create_list(:dynamic_attribute, 10)
      get :index
      expect(assigns[:dynamic_attributes].count).to eql(10)
    end
  end

  describe 'POST #create' do
    it 'should create dynamic_attribute' do
      expect {
        post :create, dynamic_attribute: {display_name: 'Test Dynamic Attribute'}
      }.to change(DynamicAttribute, :count).to(1)
    end
  end

  describe 'PATCH #update' do
    it 'should update dynamic_attribute display name' do
      dynamic_attribute = create(:dynamic_attribute)
      expect {
        patch :update, id: dynamic_attribute.id, dynamic_attribute: {display_name: 'Test Dynamic Attribute Name'}
        dynamic_attribute.reload
      }.to change(dynamic_attribute, :display_name).to('Test Dynamic Attribute Name')
    end
  end

  describe 'DELETE #destroy' do
    it 'should delete dynamic_attribute' do
      dynamic_attribute = create(:dynamic_attribute)
      expect {
        delete :destroy, id: dynamic_attribute.id
      }.to change(DynamicAttribute, :count).from(1).to(0)
    end
  end
end
