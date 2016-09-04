class AddPositionToProductType < ActiveRecord::Migration
  def change
    add_column :product_types, :broker_app_position, :integer
  end
end
