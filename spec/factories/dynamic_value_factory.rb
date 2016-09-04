FactoryGirl.define do
  factory :dynamic_value do
    association :parent, factory: :product_class
    sequence(:value) {|n| "some_value_#{n}" }
    dynamic_attribute

    trait(:product_parent) do
      association :parent, factory: :product
    end

    trait(:project_product_type_parent) do
      association :parent, factory: :project_product_type
    end
  end

  factory :dynamic_value_string, parent: :dynamic_value, class: 'DynamicValueString' do
    trait(:rate_guarantee) do
      association :dynamic_attribute, factory: [:dynamic_attribute, :rate_guarantee]
    end
  end

  factory :dynamic_value_age_band, parent: :dynamic_value, class: 'DynamicValueAgeBand' do
    value nil
  end
end
