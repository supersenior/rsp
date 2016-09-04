class Admin::ProductTypesController < AdminController
  before_filter :load_product_type, only: [:show, :update, :destroy, :edit]

  def create
    @product_type = ProductType.new(product_type_params)
    @product_type.save
    redirect_to admin_dynamic_attributes_path
  end

  def update
    if @product_type.update(product_type_params)
      redirect_to admin_dynamic_attributes_path
    else
      redirect_to action: "edit", alert: @product_type.errors.full_messages
    end
  end

  def destroy
    @product_type.destroy
    redirect_to admin_dynamic_attributes_path
  end

  private

  def load_product_type
    @product_type = ProductType.find(params[:id])
  end

  def product_type_params
    params.require(:product_type).permit(:name, :unit_rate_denominator)
  end
end
