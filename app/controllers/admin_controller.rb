class AdminController < ApplicationController
  before_action :authenticate_admin!

  private

  def impersonate_user(user)
    session[:impersonated_user_id] = user.id
  end

  def stop_impersonating_user
    session[:impersonated_user_id] = nil
  end
end
