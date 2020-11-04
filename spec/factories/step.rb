FactoryBot.define do
  factory :step do
    sequence(:number) { |n| n }
    sequence(:content) { |n| "TEST_CONTENT#{n}" }
    association :recipe
  end
end