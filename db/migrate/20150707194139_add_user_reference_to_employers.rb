class AddUserReferenceToEmployers < ActiveRecord::Migration
  def change
    add_reference :employers, :user, index: true, foreign_key: true
    remove_index :users, column: :employer_id
    remove_column :users, :employer_id, :integer
  end
end
