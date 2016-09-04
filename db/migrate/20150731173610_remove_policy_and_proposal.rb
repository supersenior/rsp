class RemovePolicyAndProposal < ActiveRecord::Migration
  def up
    remove_column :sources, :reviewable_type
    remove_column :sources, :reviewable_id

    remove_column :reviews, :reviewable_type
    remove_column :reviews, :reviewable_id

    remove_column :products, :reviewable_type
    remove_column :products, :reviewable_id

    drop_table :policies
    drop_table :proposals
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover deleted policies and proposals"
  end
end
