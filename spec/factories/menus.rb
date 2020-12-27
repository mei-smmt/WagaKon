FactoryBot.define do
  factory :menu do
    association :meal, :recipe
  end
end