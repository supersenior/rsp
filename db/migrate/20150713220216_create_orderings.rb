class CreateOrderings < ActiveRecord::Migration
  def change
    create_table :orderings do |t|
      t.string :parent_type
      t.integer :parent_id
      t.integer :order_index, default: 0
      t.integer :carrier_id

      t.timestamps null: false
    end

    add_index :orderings, [:parent_id, :parent_type]
    add_index :orderings, :carrier_id
  end
end
