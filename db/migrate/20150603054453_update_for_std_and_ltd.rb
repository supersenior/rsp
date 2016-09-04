class UpdateForStdAndLtd < ActiveRecord::Migration
  def change
    remove_column :products, :waiting_period, :string
    add_column :product_classes, :waiting_period, :string
    add_column :product_classes, :partial_disability_formula, :string
    add_column :product_classes, :earnings_test, :string
    add_column :product_classes, :full_maternity_coverage, :string
    add_column :product_classes, :employer_fica_match, :string
    add_column :product_classes, :first_day_hospital, :string
    add_column :product_classes, :first_day_outpatient_surgery, :string
    add_column :product_classes, :family_care_incentive, :string
    add_column :product_classes, :reasonable_accomodation, :string
    add_column :product_classes, :moving_expense_incentive, :string
    add_column :product_classes, :organ_donor, :string
    add_column :product_classes, :own_occupation_period, :string
    add_column :product_classes, :indexing_predisability_earnings, :string
    add_column :product_classes, :other_income_integration, :string
    add_column :product_classes, :recurrent_disability_period, :string
    add_column :product_classes, :prudent_person_language, :string
    add_column :product_classes, :drug_alcohol_limitation, :string
    add_column :product_classes, :maximum_capacity_limitation, :string
    add_column :product_classes, :forty_hour_work_week_limitation, :string
    add_column :product_classes, :mandatory_rehabilitation_limitation, :string
    add_column :product_classes, :activities_of_daily_living, :string
    add_column :product_classes, :cost_of_living_adjustment, :string
    add_column :product_classes, :family_care_inventive, :string
    add_column :product_classes, :cobra_continuance, :string
    add_column :product_classes, :pension_contribution, :string
    add_column :product_classes, :continuing_education, :string
    add_column :product_classes, :spouse_disability, :string
    add_column :product_classes, :extended_disability, :string
    add_column :product_classes, :spouse_and_elder_care, :string
    add_column :product_classes, :relocation_expense, :string
    add_column :product_classes, :retro_disability_expense, :string
    add_column :product_classes, :retro_disability_benefit, :string
    add_column :product_classes, :extended_earnings, :string
    add_column :product_classes, :specific_indemnity, :string
    add_column :product_classes, :spousal_disability, :string

    add_column :products, :employee_assistance_program, :string
    add_column :products, :social_security_filing, :string
    add_column :products, :w2_preparation, :string
  end
end
