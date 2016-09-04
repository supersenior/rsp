class AddOptionalLifeAttributes < ActiveRecord::Migration
  def change
    add_column :product_classes, :maximum_employee_coverage_percentage, :string
    add_column :product_classes, :spouse_termination_age, :string
    add_column :product_classes, :spouse_age_reductions, :string
    add_column :product_classes, :benefit_birth_to_14_days, :string
    add_column :product_classes, :benefit_14_days_to_6_months, :string
    add_column :product_classes, :benefit_6_months_to_19_years, :string
    add_column :product_classes, :dependent_child_definition, :string
    add_column :product_classes, :annual_open_enrollments, :string
  end
end
