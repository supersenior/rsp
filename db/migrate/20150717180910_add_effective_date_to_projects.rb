class AddEffectiveDateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :effective_date, :date
  end
end
