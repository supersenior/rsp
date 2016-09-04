class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name

      t.timestamps null: false
    end

    add_column :users, :organization_id, :integer
    add_index :users, :organization_id
  end
end
