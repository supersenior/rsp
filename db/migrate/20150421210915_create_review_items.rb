class CreateReviewItems < ActiveRecord::Migration
  def change
    create_table :review_items do |t|
      t.references :review, index: true, foreign_key: true
      t.integer :parent_id
      t.string :parent_type
      t.string :key
      t.integer :time
      t.boolean :did_update

      t.timestamps null: false
    end

    add_index :review_items, [:parent_id, :parent_type]
  end
end
