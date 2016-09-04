class CreatePolicies < ActiveRecord::Migration
  def change
    create_table :policies do |t|
      t.belongs_to :project
      t.belongs_to :carrier

      t.timestamps null: false
    end

    add_index :policies, :project_id
  end
end
