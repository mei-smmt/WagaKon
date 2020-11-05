FactoryBot.define do
  factory :recipe do
    sequence(:title) { |n| "TEST_TITLE#{n}" }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/factories/test.jpg')) }
    sequence(:explanation) { |n| "TEST_EXPLANATION#{n}" }
    status { "draft" }
    association :user
  end
end