class AddBasicAttributesToProductClasses < ActiveRecord::Migration
  def change
    add_column :product_classes, :title, :string
    add_column :product_classes, :broker_commission, :string
    add_column :product_classes, :description, :string
    add_column :product_classes, :waiting_period, :string
    add_column :product_classes, :benefit_calculation, :string
    add_column :product_classes, :benefit_amount, :string
    add_column :product_classes, :contributions, :string
    add_column :product_classes, :participation_requirement, :string
    add_column :product_classes, :age_reductions, :string
    add_column :product_classes, :waiver_of_premium, :string
    add_column :product_classes, :conversion, :string
    add_column :product_classes, :accelerated_death_benefit, :string

    # serialized columns
    add_column :product_classes, :guarantee_issue_amounts, :jsonb
    add_column :product_classes, :rates, :jsonb
  end
end
