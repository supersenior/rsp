class AddSourceIdToPackages < ActiveRecord::Migration
  def change
    add_reference :packages, :source, index: true, foreign_key: true
  end
end
