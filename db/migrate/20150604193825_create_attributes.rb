class CreateAttributes < ActiveRecord::Migration
  def change
    create_table :dynamic_attributes do |t|
      t.string :display_name
      t.string :parent_class

      t.timestamps null: false
    end
  end
end
