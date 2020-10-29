FactoryBot.define do
  factory :step do
    sequence(:number) { |n| n }
    sequence(:content) { |n| "TEST_CONTENT#{n}" }
    association :article
  end
end