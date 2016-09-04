class AddSelectorsToPolicies < ActiveRecord::Migration
  def change
    add_column :policies, :selectors, :text
  end
end
