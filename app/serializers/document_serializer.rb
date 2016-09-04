class DocumentSerializer < ActiveModel::Serializer
  attributes :id, :sic_code, :effective_date, :proposal_duration,
             :carrier, :source_filenames, :state, :products, :document_type, :is_archived, :is_sold

  has_many :dynamic_values

  def carrier
    CarrierSerializer.new(object.carrier, root: false)
  end

  def source_filenames
    object.sources.map(&:file_file_name).compact
  end

  def products
    products = object.products
    ActiveModel::ArraySerializer.new(products, each_serializer: ProductSerializer, root: false)
  end
end
