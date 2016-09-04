class RemoveRatesFromProductClasses < ActiveRecord::Migration
  def change
    remove_column :product_classes, :rates, :jsonb
  end
end
