class AddIndexOnOrderingsForProductType < ActiveRecord::Migration
  def change
    add_index :orderings, :product_type_id
  end
end
