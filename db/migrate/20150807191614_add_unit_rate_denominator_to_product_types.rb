class AddUnitRateDenominatorToProductTypes < ActiveRecord::Migration
  def change
    add_column :product_types, :unit_rate_denominator, :float
  end
end
