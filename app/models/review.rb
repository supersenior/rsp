class Review < ActiveRecord::Base
  belongs_to :document
  has_many :review_items, dependent: :destroy
end
