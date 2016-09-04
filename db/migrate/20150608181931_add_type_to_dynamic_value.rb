class AddTypeToDynamicValue < ActiveRecord::Migration
  def change
    add_column :dynamic_attributes, :value_type, :string
    add_column :dynamic_values, :type, :string
  end
end
