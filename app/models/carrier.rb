class Carrier < ActiveRecord::Base
  has_many :documents
  has_many :orderings, dependent: :destroy

  def proposals
    documents.where(document_type: "Proposal")
  end

  # Placeholder
  def parser
    name == "Sun Life Financial" ? Sunlife : Metlife
  end

  def average_review_time
    c = documents.count
    return 0 if c == 0
    documents.joins(reviews: :review_items).sum(:time) / c.to_f
  end

  def time_per_attribute(limit)
    ReviewItem.joins(review: {document: :carrier}).where(carriers: {id: id}).limit(limit).group(:key).order("average_time DESC").average(:time)
  end

  def ordering_for(obj, product_type)
    orderings.detect do |ordering|
      ordering.parent_type == obj.class.name && ordering.parent_id == obj.id && ordering.product_type_id == product_type.id
    end
  end

  def logo_url
    if name
      normalized_name = name.downcase.gsub(' ', '_').gsub(/_policy$/, '')

      "/carrier_logos/#{normalized_name}.jpg"
    end
  end
end
