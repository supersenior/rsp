class RemoveMetadataFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :metadata
  end
end
