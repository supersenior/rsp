class AddAdditionalAttributes < ActiveRecord::Migration
  def change
    remove_column :product_classes, :waiting_period, :string
    remove_column :product_classes, :child_tuition, :string
    remove_column :product_classes, :rate, :string
    remove_column :product_classes, :rate_basis, :string
    remove_column :product_classes, :total_volume, :string
    remove_column :product_classes, :total_monthly_premium, :string
    remove_column :product_classes, :participating_employees, :string
    remove_column :product_classes, :rate_guarantee, :string
    remove_column :product_classes, :employer_contribution, :string
    remove_column :products, :business_travel_benefit, :string

    add_column :products, :waiting_period, :string
    add_column :products, :earnings_definition, :string
    add_column :products, :indemnity_schedule, :string
    add_column :products, :child_care_expense, :string
    add_column :products, :child_tuition, :string
    add_column :products, :spouse_tution, :string
    add_column :products, :coma, :string
    add_column :products, :common_carrier, :string
    add_column :products, :dissappearance, :string
    add_column :products, :felonious_assault, :string
    add_column :products, :helmet, :string
    add_column :products, :line_of_duty, :string
    add_column :products, :spouse_benefit, :string
    add_column :products, :spouse_termination_age, :string
    add_column :products, :spouse_age_reductions, :string
    add_column :products, :child_benefit_stage_one, :string
    add_column :products, :child_benefit_stage_two, :string
    add_column :products, :child_benefit_stage_three, :string
    add_column :products, :max_percent_employee_coverage, :string
    add_column :products, :eap, :string
    add_column :products, :identity_theft, :string
    add_column :products, :legal_financial_consultation, :string
    add_column :products, :travel_assistance, :string
    add_column :products, :will_preparation, :string
    add_column :products, :rate, :string
    add_column :products, :rate_basis, :string
    add_column :products, :volume, :string
    add_column :products, :rate_guarantee, :string
    add_column :products, :package_sale_requirements, :string
  end
end
