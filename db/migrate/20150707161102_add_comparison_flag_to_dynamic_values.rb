class AddComparisonFlagToDynamicValues < ActiveRecord::Migration
  def change
    add_column :dynamic_values, :comparison_flag, :integer, default: 0
  end
end
