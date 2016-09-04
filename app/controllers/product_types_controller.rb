class ProductTypesController < ApplicationController
  before_action :authenticate_user!

  def index
    @product_types = ProductType.all
    render json: @product_types
  end
end
