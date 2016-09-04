FactoryGirl.define do
  factory :user do

    # Required attributes
    password "abc123"
    password_confirmation "abc123"
    sequence :email do |n|
      "user#{n}@example.com"
    end

    trait(:api) do
      email 'api@watchtowerbenefits.com'
      after(:create) { |user| user.add_role(:admin) }
    end
  end
end
