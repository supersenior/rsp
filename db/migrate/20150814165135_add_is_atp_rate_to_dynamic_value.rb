class AddIsAtpRateToDynamicValue < ActiveRecord::Migration
  def change
    add_column :dynamic_values, :is_atp_rate, :boolean, default: false, null: false
    remove_column :dynamic_values, :is_collapsed, :boolean, default: false
  end
end
