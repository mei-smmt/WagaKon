FactoryBot.define do
  factory :user do
    sequence(:personal_id) { |n| "id0#{n}" }
    sequence(:name) { |n| "NAME#{n}" }
    sequence(:email) { |n| "TEST#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
