class MakePackagesReviewsSourcesAndDynamicValuesAssociateWithPoliciesAsWell < ActiveRecord::Migration
  def change
    # update hardcoded proposal references to a polymorphic reference
    rename_column :packages, :proposal_id, :reviewable_id
    rename_column :reviews, :proposal_id, :reviewable_id
    rename_column :sources, :proposal_id, :reviewable_id

    add_column :packages, :reviewable_type, :string
    add_column :reviews, :reviewable_type, :string
    add_column :sources, :reviewable_type, :string

    Review.reset_column_information
    Source.reset_column_information

    Review.update_all reviewable_type: 'Proposal'
    Source.update_all reviewable_type: 'Proposal'
  end
end
