FactoryBot.define do
  factory :relationship do
    association :user
    association :friend, class_name: 'User'
    status { "requesting" }
  end
end