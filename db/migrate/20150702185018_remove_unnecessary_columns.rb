class RemoveUnnecessaryColumns < ActiveRecord::Migration
  def change
    remove_column :product_classes, :benefit_calculation, :string
    remove_column :product_classes, :benefit_amount, :string
    remove_column :product_classes, :contributions, :string
    remove_column :product_classes, :participation_requirement, :string
    remove_column :product_classes, :age_reductions, :string
    remove_column :product_classes, :waiver_of_premium, :string
    remove_column :product_classes, :conversion, :string
    remove_column :product_classes, :accelerated_death_benefit, :string
    remove_column :product_classes, :guarantee_issue_amounts, :string
    remove_column :product_classes, :benefit_schedule, :string
    remove_column :product_classes, :benefit_maximum, :string
    remove_column :product_classes, :benefit_minimum, :string
    remove_column :product_classes, :rounding_rules, :string
    remove_column :product_classes, :guarantee_issue, :string
    remove_column :product_classes, :age_reduction_schedule, :string
    remove_column :product_classes, :portability, :string
    remove_column :product_classes, :employer_contribution_percent, :string
    remove_column :product_classes, :eligible_employees, :string
    remove_column :product_classes, :total_eligible_employees, :string
    remove_column :product_classes, :elimination_period, :string
    remove_column :product_classes, :benefit_duration, :string
    remove_column :product_classes, :rehabilitation_incentive_benefit, :string
    remove_column :product_classes, :disability_definition, :string
    remove_column :product_classes, :survivor_benefit, :string
    remove_column :product_classes, :social_security_offsets, :string
    remove_column :product_classes, :pre_existing_conditions, :string
    remove_column :product_classes, :self_reported_limitation, :string
    remove_column :product_classes, :mental_nervous_limitation, :string
    remove_column :product_classes, :zero_day_residual, :string
    remove_column :product_classes, :trial_work_days, :string
    remove_column :product_classes, :return_to_work_incentive, :string
    remove_column :product_classes, :waiting_period, :string
    remove_column :product_classes, :partial_disability_formula, :string
    remove_column :product_classes, :earnings_test, :string
    remove_column :product_classes, :full_maternity_coverage, :string
    remove_column :product_classes, :employer_fica_match, :string
    remove_column :product_classes, :first_day_hospital, :string
    remove_column :product_classes, :first_day_outpatient_surgery, :string
    remove_column :product_classes, :family_care_incentive, :string
    remove_column :product_classes, :reasonable_accomodation, :string
    remove_column :product_classes, :moving_expense_incentive, :string
    remove_column :product_classes, :organ_donor, :string
    remove_column :product_classes, :own_occupation_period, :string
    remove_column :product_classes, :indexing_predisability_earnings, :string
    remove_column :product_classes, :other_income_integration, :string
    remove_column :product_classes, :recurrent_disability_period, :string
    remove_column :product_classes, :prudent_person_language, :string
    remove_column :product_classes, :drug_alcohol_limitation, :string
    remove_column :product_classes, :maximum_capacity_limitation, :string
    remove_column :product_classes, :forty_hour_work_week_limitation, :string
    remove_column :product_classes, :mandatory_rehabilitation_limitation, :string
    remove_column :product_classes, :activities_of_daily_living, :string
    remove_column :product_classes, :cost_of_living_adjustment, :string
    remove_column :product_classes, :family_care_inventive, :string
    remove_column :product_classes, :cobra_continuance, :string
    remove_column :product_classes, :pension_contribution, :string
    remove_column :product_classes, :continuing_education, :string
    remove_column :product_classes, :spouse_disability, :string
    remove_column :product_classes, :extended_disability, :string
    remove_column :product_classes, :spouse_and_elder_care, :string
    remove_column :product_classes, :relocation_expense, :string
    remove_column :product_classes, :retro_disability_expense, :string
    remove_column :product_classes, :extended_earnings, :string
    remove_column :product_classes, :specific_indemnity, :string
    remove_column :product_classes, :spousal_disability, :string
    remove_column :product_classes, :occupational_coverage, :string
    remove_column :product_classes, :maximum_employee_coverage_percentage, :string
    remove_column :product_classes, :spouse_termination_age, :string
    remove_column :product_classes, :spouse_age_reductions, :string
    remove_column :product_classes, :benefit_birth_to_14_days, :string
    remove_column :product_classes, :benefit_14_days_to_6_months, :string
    remove_column :product_classes, :benefit_6_months_to_19_years, :string
    remove_column :product_classes, :dependent_child_definition, :string
    remove_column :product_classes, :annual_open_enrollments, :string
    remove_column :product_classes, :retro_disability_benefit, :string

    remove_column :products, :eligibility, :string
    remove_column :products, :funding, :string
    remove_column :products, :broker_commission, :string
    remove_column :products, :air_bag_benefit, :string
    remove_column :products, :seatbelt_benefit, :string
    remove_column :products, :repatriation, :string
    remove_column :products, :catastrophic_loss, :string
    remove_column :products, :child_tution, :string
    remove_column :products, :earnings_definition, :string
    remove_column :products, :indemnity_schedule, :string
    remove_column :products, :child_care_expense, :string
    remove_column :products, :child_tuition, :string
    remove_column :products, :spouse_tution, :string
    remove_column :products, :coma, :string
    remove_column :products, :common_carrier, :string
    remove_column :products, :dissappearance, :string
    remove_column :products, :felonious_assault, :string
    remove_column :products, :helmet, :string
    remove_column :products, :line_of_duty, :string
    remove_column :products, :spouse_benefit, :string
    remove_column :products, :spouse_termination_age, :string
    remove_column :products, :spouse_age_reductions, :string
    remove_column :products, :child_benefit_stage_one, :string
    remove_column :products, :child_benefit_stage_two, :string
    remove_column :products, :child_benefit_stage_three, :string
    remove_column :products, :max_percent_employee_coverage, :string
    remove_column :products, :eap, :string
    remove_column :products, :identity_theft, :string
    remove_column :products, :legal_financial_consultation, :string
    remove_column :products, :travel_assistance, :string
    remove_column :products, :will_preparation, :string
    remove_column :products, :rate, :string
    remove_column :products, :rate_basis, :string
    remove_column :products, :volume, :string
    remove_column :products, :rate_guarantee, :string
    remove_column :products, :package_sale_requirements, :string
    remove_column :products, :employee_assistance_program, :string
    remove_column :products, :w2_preparation, :string
    remove_column :products, :business_travel, :string
    remove_column :products, :social_security_filing, :string
  end
end