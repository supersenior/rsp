class AddCompoundIndexOnDynamicValues < ActiveRecord::Migration
  def change
    remove_index :dynamic_values, :parent_id
    remove_index :dynamic_values, :parent_type

    add_index :dynamic_values, [:parent_type, :parent_id]
  end
end
