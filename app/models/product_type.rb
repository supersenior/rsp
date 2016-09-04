class ProductType < ActiveRecord::Base
  default_scope { order(:broker_app_position) }
  has_and_belongs_to_many :dynamic_attributes
end
