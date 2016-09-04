class AddProjectProductTypeJoinTable < ActiveRecord::Migration
  def change
    create_table :project_product_types do |t|
      t.references :project, index: true, null: false
      t.references :product_type, index: true, null: false
      t.boolean :inforce, default: false

      t.timestamps null: false
    end
  end
end
