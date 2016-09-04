class AssociateUsersWithProjects < ActiveRecord::Migration
  def change
    add_reference :users, :employer, index: true, foreign_key: true
    add_reference :projects, :user,  index: true, foreign_key: true
  end
end
