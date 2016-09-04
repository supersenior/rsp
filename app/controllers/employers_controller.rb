class EmployersController < ApplicationController
  before_action :authenticate_user!

  def index
    @employers = current_user.employers
    render json: @employers
  end
end
