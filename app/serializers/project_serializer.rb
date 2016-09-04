class ProjectSerializer < ActiveModel::Serializer
  attributes :created_at, :last_opened_at, :id

  has_many :proposals, :policies, :project_product_types

  def last_opened_at
    rand(10).months.ago
  end
end
