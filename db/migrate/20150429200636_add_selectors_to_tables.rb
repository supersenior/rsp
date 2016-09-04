class AddSelectorsToTables < ActiveRecord::Migration
  def change
    add_column :proposals, :selectors, :text
    add_column :packages, :selectors, :text
    add_column :products, :selectors, :text
    add_column :product_classes, :selectors, :text
  end
end
