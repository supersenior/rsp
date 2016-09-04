class Admin::ProductsController < AdminController
  include Reviewable
  include HasDynamicAttributes

  before_filter :load_document, only: [:create]
  before_filter :load_product, only: [:show, :update, :destroy]

  def create
    @product = @document.products.new(product_params)
    if !@product.save
      flash[:error] = @product.errors.full_messages.join(". ")
    end
    redirect_to admin_document_path(@document, anchor: "product-#{@product.id}")
  end

  def destroy
    @product.destroy
    redirect_to admin_document_path(@product.document)
  end

  def update
    add_review_item(@product, params[:attribute_id], @metadata)
    update_dynamic_attribute(@product)

    if params[:product]
      if @product.update(product_params)
        head :ok
      else
        render json: {errors: @product.errors.full_messages}, status: :unprocessable_entity
      end
    else
      head :ok
    end
  end

  private

  def product_params
    params.require(:product).permit((Product.column_names - ["id", "document_id", "created_at", "updated_at", "selectors"]).map(&:to_sym))
  end

  def load_document
    @document = Document.find(params[:document_id])
  end

  def load_product
    @product = Product.find(params[:id])
  end
end
