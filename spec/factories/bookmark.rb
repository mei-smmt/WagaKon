FactoryBot.define do
  factory :bookmark do
    association :user, :article
  end
end