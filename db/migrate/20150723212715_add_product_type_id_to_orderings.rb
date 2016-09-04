class AddProductTypeIdToOrderings < ActiveRecord::Migration
  def change
    add_column :orderings, :product_type_id, :integer
  end
end
