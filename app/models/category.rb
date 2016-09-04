class Category < ActiveRecord::Base
  has_many :dynamic_attributes
  has_many :orderings, as: :parent
end
