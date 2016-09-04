class AddIsSoldToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :is_sold, :boolean, default: false
  end
end
