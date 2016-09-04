class ReviewItem < ActiveRecord::Base
  belongs_to :review
  belongs_to :parent, polymorphic: true
end
