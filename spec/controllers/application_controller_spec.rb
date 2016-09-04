require 'rails_helper'

describe ApplicationController do
  controller do
    before_action :authenticate_user!

    def index
      render text: 'success'
    end
  end

  it 'should redirect to the log in path if not logged in' do
    get :index

    expect(response).to redirect_to(log_in_path)
  end

  it 'renders an error flash if not logged in' do
    get :index

    expect(flash[:error]).to be_present
  end

  it 'should be successful if logged in' do
    expect(controller).to receive(:current_user) { User.new }

    get :index

    expect(response).to be_success
  end

  it 'should verify the authenticity token for non-api requests' do
    expect(controller).to receive(:verify_authenticity_token)

    get :index
  end

  it 'should NOT verify the authenticity token for API requests' do
    allow(controller).to receive(:api_request?) { true }
    expect(controller).to_not receive(:verify_authenticity_token)

    get :index
  end
end
