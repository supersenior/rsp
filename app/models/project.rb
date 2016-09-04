class Project < ActiveRecord::Base
  belongs_to :employer
  belongs_to :user
  has_many :documents
  has_many :project_product_types
  has_many :product_types, through: :project_product_types

  validates_presence_of :employer
  validates :effective_date, presence: true
  accepts_nested_attributes_for :project_product_types

  def proposals
    documents.where(document_type: 'Proposal')
  end

  def policies
    documents.where(document_type: 'Policy')
  end

  def mark_as_sold(proposal)
    return false if documents(true).any?(&:is_sold?) # reload associations

    proposal.update(is_sold: true)
  end

  def documents_for_export
    # keep order of default association
    # sort_by changes the default order
    document_list = documents.finalized.where(is_archived: false).includes(:carrier)
    document_ids = document_list.pluck :id
    document_list.sort_by{|doc| doc.document_type == 'Policy' ? 0 : document_ids.index(doc.id) + 1 }
  end

  def name=(name)
    employer.update name: name
  end
end
