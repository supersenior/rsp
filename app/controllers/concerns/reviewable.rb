module Reviewable
  extend ActiveSupport::Concern

  def add_review_item(item, key, metadata = {})
    reviewable = item.is_a?(Document) ? item : item.document
    return if key.nil? || reviewable.nil?
    review = reviewable.review_for_state
    review.review_items.create(metadata.merge(parent: item, key: key))
  end
end
