FactoryBot.define do
  factory :bookmark do
    association :user, :recipe
  end
end