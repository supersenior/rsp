require 'rails_helper'

describe Admin::UsersController do
  let(:user) { create(:user, :api) }
  let(:user1) { create(:user) }
  before(:each) do
    allow_any_instance_of(Admin::UsersController).to receive(:true_user).and_return(user)
  end

  describe 'GET #impersonate' do
    it 'should allow to login with other user' do
      get :impersonate, id: user1.id
      expect(flash[:notice]).to eql("Impersonating #{user1.email}")
    end
  end

  describe 'GET #stop_impersonating' do
    it 'should stop impersonating' do
      get :impersonate, id: user1.id
      expect(flash[:notice]).to eql("Impersonating #{user1.email}")

      get :stop_impersonating
      expect(flash[:notice]).to eql("Stopped impersonating user")
    end
  end
end
