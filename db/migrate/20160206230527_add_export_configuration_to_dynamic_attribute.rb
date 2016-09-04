class AddExportConfigurationToDynamicAttribute < ActiveRecord::Migration
  def change
    enable_extension 'hstore'
    add_column :dynamic_attributes, :export_configuration, :hstore
    add_index :dynamic_attributes, :export_configuration, using: :gist
  end
end
