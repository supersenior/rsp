FactoryGirl.define do
  factory :product_type do
    sequence(:name) {|n| "Name #{n}" }
  end
end
