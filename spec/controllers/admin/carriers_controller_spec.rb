require 'rails_helper'

describe Admin::CarriersController do
  let(:user) { create(:user, :api) }
  before(:each) do
    allow_any_instance_of(Admin::CarriersController).to receive(:true_user).and_return(user)
  end

  describe 'GET #index' do
    it 'should retrieve all carriers' do
      create_list(:carrier, 10)
      get :index
      expect(assigns[:carriers].count).to eql(10)
    end
  end

  describe 'POST #create' do
    it 'should create carrier' do
      expect {
        post :create, carrier: {name: 'Test Carrier'}
      }.to change(Carrier, :count).to(1)
    end
  end

  describe 'PATCH #update' do
    it 'should update carrier name' do
      carrier = create(:carrier)
      expect {
        patch :update, id: carrier.id, carrier: {name: 'Test Carrier'}
        carrier.reload
      }.to change(carrier, :name).to('Test Carrier')
    end
  end

  describe 'DELETE #destroy' do
    it 'should delete carrier' do
      carrier = create(:carrier)
      expect {
        delete :destroy, id: carrier.id
      }.to change(Carrier, :count).from(1).to(0)
    end
  end
end
