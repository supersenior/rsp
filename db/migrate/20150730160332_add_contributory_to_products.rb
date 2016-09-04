class AddContributoryToProducts < ActiveRecord::Migration
  def change
    add_column :products, :contributory, :boolean, default: true, null: false
    remove_column :proposals, :contributory, :boolean
    remove_column :policies, :contributory, :boolean
  end
end
