class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.belongs_to :package

      t.timestamps null: false
    end

    add_index :products, :package_id
  end
end
