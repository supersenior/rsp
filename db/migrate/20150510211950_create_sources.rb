class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.references :proposal, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_attachment :sources, :file
  end
end
