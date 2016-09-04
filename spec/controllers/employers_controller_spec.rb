require 'rails_helper'

describe EmployersController do

  let(:user) { create(:user) }
  before(:each) do
    allow_any_instance_of(EmployersController).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    it 'should return all user employers' do
      employers = create_list(:employer, 10, user: user)
      get :index, format: :json
      expect(assigns[:employers].count).to eql(employers.length)
    end
  end

end