class AddColumnsToCarriersAndEmployers < ActiveRecord::Migration
  def change
    add_column :carriers, :address1, :string
    add_column :carriers, :address2, :string
    add_column :carriers, :city, :string
    add_column :carriers, :state, :string
    add_column :carriers, :zipcode, :string
    add_column :carriers, :logo_url, :string

    add_column :employers, :address1, :string
    add_column :employers, :address2, :string
    add_column :employers, :city, :string
    add_column :employers, :state, :string
    add_column :employers, :sic_code, :string
  end
end
