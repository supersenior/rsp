class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit!)

    if @user.save
      session[:user_id] = @user.id # log-in the new user

      redirect_to root_url, :notice => "Signed up!"
    else
      render :new
    end
  end
end
