class RemoveSourceFileFromProposals < ActiveRecord::Migration
  def change
    remove_column :proposals, :html_source, :text
    remove_column :proposals, :source_file_file_name, :string
    remove_column :proposals, :source_file_content_type, :string
    remove_column :proposals, :source_file_file_size, :string
    remove_column :proposals, :source_file_updated_at, :datetime
  end
end
