class AddIsRateToDynamicAttributes < ActiveRecord::Migration
  def change
    add_column :dynamic_attributes, :is_rate, :boolean, default: false
  end
end
