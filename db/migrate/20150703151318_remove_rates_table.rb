class RemoveRatesTable < ActiveRecord::Migration
  def down
    create_table :rates do |t|
      t.string :rate_basis
      t.float :monthly_rate
      t.integer :total_volume
      t.string :rate_guarantee
      t.integer :total_annual_premium
      t.integer :total_monthly_premium
      t.integer :total_eligible_employees
      t.references :product_class, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

  def up
    drop_table :rates
  end
end
