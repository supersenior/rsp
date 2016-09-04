class Admin::ProductClassesController < AdminController
  include Reviewable
  include HasDynamicAttributes

  before_filter :load_product, only: [:create]
  before_filter :load_product_class, only: [:show, :update, :destroy]

  def update
    add_review_item(@product_class, params[:attribute_id])
    update_dynamic_attribute(@product_class)

    head :ok
  end

  def create
    @product_class = @product.product_classes.new

    if @product_class.save
      @product_class.create_values_for_attributes
    else
      flash[:error] = @product_class.errors.full_messages.join(". ")
    end

    redirect_to admin_document_path(@product.document, anchor: "class-#{@product_class.id}")
  end

  def destroy
    @product_class.destroy

    redirect_to admin_document_path(@product_class.product.document)
  end

  private

  def product_class_params
    params.require(:product_class).permit((ProductClass.column_names - ["id", "product_id", "created_at", "updated_at", "selectors"]).map(&:to_sym))
  end

  def load_product_class
    @product_class = ProductClass.find(params[:id])
  end

  def load_product
    @product = Product.find(params[:product_id])
  end
end
