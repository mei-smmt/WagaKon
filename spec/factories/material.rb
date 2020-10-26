FactoryBot.define do
  factory :material do
    sequence(:name) { |n| "TEST_NAME#{n}" }
    sequence(:quantity) { |n| "TEST_QUANTITY#{n}" }
    association :article
  end
end