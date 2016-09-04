class AddIsArchivedToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :is_archived, :boolean, default: false
  end
end
