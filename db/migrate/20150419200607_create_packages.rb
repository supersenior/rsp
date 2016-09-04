class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.belongs_to :proposal

      t.timestamps null: false
    end

    add_index :packages, :proposal_id
  end
end
