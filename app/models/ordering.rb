class Ordering < ActiveRecord::Base
  belongs_to :parent, polymorphic: true
  belongs_to :carrier
  belongs_to :product_type
end
