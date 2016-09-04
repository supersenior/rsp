class AddAdditionalFields < ActiveRecord::Migration
  def change
    add_column :products, :eligibility, :string
    add_column :products, :funding, :string
    add_column :products, :broker_commission, :string

    add_column :products, :air_bag_benefit, :string
    add_column :products, :seatbelt_benefit, :string
    add_column :products, :repatriation, :string
    add_column :products, :business_travel_benefit, :string
    add_column :products, :catastrophic_loss, :string
    add_column :products, :child_tution, :string

    add_column :product_classes, :benefit_schedule, :string
    add_column :product_classes, :benefit_maximum, :string
    add_column :product_classes, :benefit_minimum, :string
    add_column :product_classes, :rounding_rules, :string
    add_column :product_classes, :guarantee_issue , :string
    add_column :product_classes, :age_reduction_schedule, :string
    add_column :product_classes, :portability, :string
    add_column :product_classes, :employer_contribution_percent, :string
    add_column :product_classes, :eligible_employees, :string
    add_column :product_classes, :rate, :string
    add_column :product_classes, :rate_basis, :string
    add_column :product_classes, :total_volume, :string
    add_column :product_classes, :total_monthly_premium, :string
    add_column :product_classes, :rate_guarantee, :string

    remove_column :product_classes, :broker_commission, :string
  end
end
