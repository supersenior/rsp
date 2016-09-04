class CreateProductClasses < ActiveRecord::Migration
  def change
    create_table :product_classes do |t|
      t.belongs_to :product

      t.timestamps null: false
    end

    add_index :product_classes, :product_id
  end
end
