class AddIsCollapsedToDynamicValues < ActiveRecord::Migration
  def change
    add_column :dynamic_values, :is_collapsed, :boolean, default: false
  end
end
