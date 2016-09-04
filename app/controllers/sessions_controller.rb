class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email].try(:downcase), params[:password])

    if user
      session[:user_id] = user.id
      redirect_url = session[:return_url] || root_url

      redirect_to redirect_url, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"

      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    session[:impersonated_user_id] = nil

    redirect_to root_url, :notice => "Logged out!"
  end
end
