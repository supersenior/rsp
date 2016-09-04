class Admin::DynamicAttributesController < AdminController
  before_filter :load_dynamic_attribute, only: [:show, :update, :destroy, :edit]

  def index
    @dynamic_attributes = DynamicAttribute.all
  end

  def create
    @dynamic_attribute = DynamicAttribute.new(dynamic_attribute_params)
    if !@dynamic_attribute.save
      flash.alert = @dynamic_attribute.errors.full_messages
    end
    redirect_to admin_dynamic_attributes_path
  end

  def update
    if @dynamic_attribute.update(dynamic_attribute_params)
      redirect_to admin_dynamic_attributes_path
    else
      redirect_to action: "edit", alert: @dynamic_attribute.errors.full_messages
    end
  end

  def destroy
    @dynamic_attribute.destroy
    redirect_to action: "index"
  end

  private

  def load_dynamic_attribute
    @dynamic_attribute = DynamicAttribute.find(params[:id])
  end

  def dynamic_attribute_params
    params.require(:dynamic_attribute).permit(:display_name, :parent_class, :value_type, :required, :attribute_order, :category_id, :attribute_order, :is_rate, product_type_ids: [])
  end
end
