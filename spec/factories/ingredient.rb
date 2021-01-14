FactoryBot.define do
  factory :ingredient do
    sequence(:name) { |n| "NAME#{n}" }
    sequence(:quantity) { |n| "QUANTITY#{n}" }
    association :recipe
  end
end