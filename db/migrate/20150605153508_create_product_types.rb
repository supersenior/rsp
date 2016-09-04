class CreateProductTypes < ActiveRecord::Migration
  def change
    create_table :product_types do |t|
      t.string :name

      t.timestamps null: false
    end

    create_join_table :dynamic_attributes, :product_types do |t|
      t.index :dynamic_attribute_id
      t.index :product_type_id
    end

    add_reference :products, :product_type, index: true
    add_foreign_key :products, :product_types
    remove_column :products, :product_type, :string
  end
end
