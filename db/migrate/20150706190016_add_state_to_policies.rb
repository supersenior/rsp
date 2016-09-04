class AddStateToPolicies < ActiveRecord::Migration
  def change
    add_column :policies, :state, :integer, default: 0
  end
end
