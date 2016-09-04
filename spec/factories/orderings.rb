FactoryGirl.define do
  factory :ordering do
    association :parent, factory: :dynamic_attribute
    order_index 1
  end

end
