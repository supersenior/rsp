class CreateValues < ActiveRecord::Migration
  def change
    create_table :dynamic_values do |t|
      t.references :dynamic_attribute, index: true, foreign_key: true
      t.integer :parent_id, index: true
      t.string :parent_type, index: true
      t.string :value

      t.timestamps null: false
    end
  end
end
