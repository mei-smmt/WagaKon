FactoryBot.define do
  factory :meal do
    day_of_week { "sun" }
    association :user
  end
end