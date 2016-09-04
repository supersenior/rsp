class AddMetadataToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :metadata, :text
  end
end
