class AddAttributesToStd < ActiveRecord::Migration
  def change
    add_column :product_classes, :occupational_coverage, :string
  end
end
