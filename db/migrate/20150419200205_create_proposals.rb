class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.text :html_source
      t.integer :project_id, index: true, foreign_key: true
      t.integer :carrier_id, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
