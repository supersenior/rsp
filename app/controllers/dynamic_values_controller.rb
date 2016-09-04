class DynamicValuesController < ApplicationController
  before_action :authenticate_user!
  before_filter :load_dynamic_value

  def update
    @dynamic_value.discrepency = params[:discrepency]
    @dynamic_value.save!

    respond_to do |format|
      format.json { render json: {}, status: :ok }
    end
  end

  private
  def load_dynamic_value
    dv = DynamicValue.find params[:id]
    if dv.user != current_user
      raise ActiveRecord::RecordNotFound
    else
      @dynamic_value = dv
    end
  end
end
