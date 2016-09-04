class AddPdfAttachmentToProposal < ActiveRecord::Migration
  def self.up
    add_attachment :proposals, :source_file
  end

  def self.down
    remove_attachment :proposals, :source_file
  end
end
