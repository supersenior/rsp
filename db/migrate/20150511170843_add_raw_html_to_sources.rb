class AddRawHtmlToSources < ActiveRecord::Migration
  def change
    add_column :sources, :raw_html, :text
  end
end
