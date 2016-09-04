class AddStateToProposal < ActiveRecord::Migration
  def change
    add_column :proposals, :state, :integer, default: 0
    rename_column :products, :title, :product_type
  end
end
