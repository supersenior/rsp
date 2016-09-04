FactoryGirl.define do
  factory :project do
    user
    employer
    effective_date 1.month.from_now.to_date
  end
end
