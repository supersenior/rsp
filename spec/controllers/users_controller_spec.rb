require 'rails_helper'

describe UsersController do
  let(:user) { attributes_for(:user) }

  describe "GET #new" do
    xit "assigns a new user as @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do
  end
end