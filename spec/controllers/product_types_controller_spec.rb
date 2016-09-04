require 'rails_helper'

describe ProductTypesController do
  let(:user) { create(:user) }
  before(:each) do
    allow_any_instance_of(ProductTypesController).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    it 'should return all product types' do
      product_types = create_list(:product_type, 10)
      get :index, format: :json
      expect(assigns[:product_types].count).to eql(product_types.length)
    end
  end
end