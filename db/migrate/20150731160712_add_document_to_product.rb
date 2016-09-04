class AddDocumentToProduct < ActiveRecord::Migration
  def change
    add_reference :products, :document, index: true, foreign_key: true
    add_reference :reviews, :document, index: true, foreign_key: true
    add_reference :sources, :document, index: true, foreign_key: true
  end
end
