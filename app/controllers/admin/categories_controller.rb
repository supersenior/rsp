class Admin::CategoriesController < AdminController
  before_filter :load_category, only: [:show, :update, :destroy, :edit]

  def create
    @category = Category.new(category_params)
    @category.save
    redirect_to admin_dynamic_attributes_path
  end

  def update
    if @category.update(category_params)
      redirect_to admin_dynamic_attributes_path
    else
      redirect_to action: "edit", alert: @category.errors.full_messages
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_dynamic_attributes_path
  end

  private

  def load_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :category_order)
  end
end
