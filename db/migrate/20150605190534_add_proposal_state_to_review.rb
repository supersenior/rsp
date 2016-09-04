class AddProposalStateToReview < ActiveRecord::Migration
  def change
    remove_column :reviews, :guid, :string
    add_column :reviews, :proposal_state, :integer
  end
end
