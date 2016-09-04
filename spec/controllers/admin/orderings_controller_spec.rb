require 'rails_helper'

describe Admin::OrderingsController do
  let(:user) { create(:user, :api) }
  let(:carrier) { create(:carrier) }
  before(:each) do
    allow_any_instance_of(Admin::OrderingsController).to receive(:true_user).and_return(user)
  end

  describe 'GET #index' do
    it 'should retrieve all orderings' do
      create_list(:ordering, 10, carrier: carrier)
      get :index, carrier_id: carrier.id
      expect(assigns[:orderings].count).to eql(10)
    end
  end

  describe 'POST #create' do
    it 'should create ordering' do
      da = create(:dynamic_attribute)
      expect {
        post :create, carrier_id: carrier.id, ordering: {parent_type: 'DynamicAttribute', parent_id: da.id, order_index: 1}
      }.to change(Ordering, :count).to(1)
    end
  end

  describe 'PATCH #update' do
    it 'should update ordering index' do
      ordering = create(:ordering)
      expect {
        patch :update, carrier_id: carrier.id, id: ordering.id, ordering: {order_index: 10}
        ordering.reload
      }.to change(ordering, :order_index).to(10)
    end
  end

  describe 'DELETE #destroy' do
    it 'should delete ordering' do
      ordering = create(:ordering)
      expect {
        delete :destroy, id: ordering.id, carrier_id: carrier.id
      }.to change(Ordering, :count).from(1).to(0)
    end
  end
end
