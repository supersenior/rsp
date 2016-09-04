class AddMoreAttributesAgain < ActiveRecord::Migration
  def change
    add_column :products, :business_travel, :string
  end
end
