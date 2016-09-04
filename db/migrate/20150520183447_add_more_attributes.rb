class AddMoreAttributes < ActiveRecord::Migration
  def change
    add_column :product_classes, :participating_employees, :string
    add_column :product_classes, :total_eligible_employees, :string
    add_column :product_classes, :employer_contribution, :string
    add_column :product_classes, :child_tuition, :string
    add_column :product_classes, :elimination_period, :string
    add_column :product_classes, :benefit_duration, :string
    add_column :product_classes, :rehabilitation_incentive_benefit, :string
    add_column :product_classes, :disability_definition, :string
    add_column :product_classes, :survivor_benefit, :string
    add_column :product_classes, :social_security_offsets, :string
    add_column :product_classes, :pre_existing_conditions, :string
    add_column :product_classes, :self_reported_limitation, :string
    add_column :product_classes, :mental_nervous_limitation, :string
    add_column :product_classes, :zero_day_residual, :string
    add_column :product_classes, :trial_work_days, :string
    add_column :product_classes, :return_to_work_incentive, :string
  end
end
