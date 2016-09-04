class AddClassNumberToProductClass < ActiveRecord::Migration
  def change
    remove_column :product_classes, :title, :string
    add_column :product_classes, :class_number, :integer
  end
end
