FactoryBot.define do
  factory :relationship do
    association :user, :friend
    status { "requesting" }
  end
end