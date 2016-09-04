require 'rails_helper'

describe SessionsController do
  let(:user) { create(:user) }

  describe "GET #new" do
    it "returns http success" do
      get :new

      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'should check email and password' do
      expect(
        post :create, email: user.email, password: 'incorrect password'
      ).to render_template(:new)
      expect(session[:user_id]).to eql(nil)
    end

    it 'should sign in with correct email and password' do
      post :create, email: user.email, password: 'abc123'
      expect(session[:user_id]).to eql(user.id)
    end
  end

  describe 'DELETE #destroy' do
    it 'should signout current user' do
      post :create, email: user.email, password: 'abc123'
      expect {
        delete :destroy
      }.to change{session[:user_id]}.from(user.id).to(nil)
    end
  end
end
