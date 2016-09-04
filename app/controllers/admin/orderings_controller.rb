class Admin::OrderingsController < AdminController
  before_filter :load_carrier
  before_filter :load_ordering, only: [:show, :update, :destroy, :edit]

  def index
    @orderings = @carrier.orderings
    @product_type = ProductType.find(params[:product_type_id]) if params[:product_type_id]
  end

  def create
    @ordering = @carrier.orderings.new(ordering_params)
    if !@ordering.save
      flash.alert = @ordering.errors.full_messages
    end
    redirect_to action: "index", product_type_id: @ordering.product_type_id
  end

  def update
    if @ordering.update(ordering_params)
      redirect_to action: "index", product_type_id: @ordering.product_type_id
    else
      render action: :edit, alert: @ordering.errors.full_messages
    end
  end

  def destroy
    @ordering.destroy
    redirect_to action: "index", product_type_id: @ordering.product_type_id
  end

  private

  def load_carrier
    @carrier = Carrier.find(params[:carrier_id])
  end

  def load_ordering
    @ordering = Ordering.find(params[:id])
  end

  def ordering_params
    params.require(:ordering).permit(:order_index, :parent_type, :parent_id, :product_type_id)
  end
end
