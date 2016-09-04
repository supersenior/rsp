FactoryGirl.define do
  factory :dynamic_attribute do
    required false
    value_type "DynamicValueString"
    sequence(:display_name) {|n| "Name #{n}" }

    trait(:class_description) do
      display_name 'Class Description'
    end

    trait(:rate_guarantee) do
      display_name 'Rate Guarantee'
    end

    trait(:commission) do
      display_name 'Commission'
    end

    trait(:rate) do
      display_name 'Rate'
    end
  end
end
