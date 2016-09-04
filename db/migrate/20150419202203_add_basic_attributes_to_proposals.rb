class AddBasicAttributesToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :sic_code, :string
    add_column :proposals, :effective_date, :date
    add_column :proposals, :proposal_duration, :int
  end
end
