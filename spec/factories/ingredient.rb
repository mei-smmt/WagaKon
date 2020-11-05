FactoryBot.define do
  factory :ingredient do
    sequence(:name) { |n| "TEST_NAME#{n}" }
    sequence(:quantity) { |n| "TEST_QUANTITY#{n}" }
    association :recipe
  end
end