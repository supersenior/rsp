class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :sic_code
      t.date :effective_date
      t.integer :proposal_duration
      t.integer :state, default: 0
      t.text :selectors
      t.string :document_type

      t.belongs_to :project
      t.belongs_to :carrier

      t.timestamps
    end

    add_index :documents, :carrier_id
    add_index :documents, :project_id
  end
end
