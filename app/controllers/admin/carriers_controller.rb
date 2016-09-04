class Admin::CarriersController < AdminController
  before_filter :load_carrier, only: [:show, :update, :destroy, :edit]

  def index
    @carriers = Carrier.all
  end

  def create
    @carrier = Carrier.new(carrier_params)
    if !@carrier.save
      flash.alert = @carrier.errors.full_messages
    end
    redirect_to admin_carriers_path
  end

  def update
    if @carrier.update(carrier_params)
      redirect_to admin_carriers_path
    else
      render action: :edit, alert: @carrier.errors.full_messages
    end
  end

  def destroy
    @carrier.destroy
    redirect_to action: "index"
  end

  private

  def load_carrier
    @carrier = Carrier.find(params[:id])
  end

  def carrier_params
    params.require(:carrier).permit(:name)
  end
end
