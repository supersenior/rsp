FactoryGirl.define do
  factory :category do
    name "MyString"
    sequence :category_order do |n|
      n + 1
    end
  end

end
