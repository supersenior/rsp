class AddRequiredToDynamicAttribute < ActiveRecord::Migration
  def change
    add_column :dynamic_attributes, :required, :boolean, default: false
  end
end
