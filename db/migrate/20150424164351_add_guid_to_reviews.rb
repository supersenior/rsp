class AddGuidToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :guid, :string, index: true
  end
end
