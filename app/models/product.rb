class Product < ActiveRecord::Base
  include DistillableAttributes

  belongs_to :document
  belongs_to :product_type
  has_many :product_classes, dependent: :destroy
  has_many :dynamic_values, as: :parent, dependent: :destroy

  serialize :selectors, Hash
  delegate :user, to: :document
  delegate :unit_rate_denominator, to: :product_type

  def title
    Settings.types.product.subtypes[product_type].try(:display_name) || "Unrecognized Type"
  end
end
