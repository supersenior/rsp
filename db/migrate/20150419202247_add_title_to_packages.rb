class AddTitleToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :title, :string
  end
end
