FactoryGirl.define do
  factory :review_item do
    sequence(:time) { |n| n + 1 }
  end
end