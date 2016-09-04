class AddContributoryToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :contributory, :boolean, default: true, null: false
    add_column :policies, :contributory, :boolean, default: true, null: false
  end
end
