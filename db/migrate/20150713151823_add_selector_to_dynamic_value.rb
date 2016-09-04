class AddSelectorToDynamicValue < ActiveRecord::Migration
  def change
    add_column :dynamic_values, :selector, :string
  end
end
