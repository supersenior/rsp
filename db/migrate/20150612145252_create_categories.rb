class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :category_order

      t.timestamps null: false
    end

    add_column :dynamic_attributes, :category_id, :integer
    add_column :dynamic_attributes, :attribute_order, :integer
  end
end
