class RemoveForeignKeyConstraintFromSources < ActiveRecord::Migration
  def change
    remove_foreign_key :sources, :reviewable
  end
end
