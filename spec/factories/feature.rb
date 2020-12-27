FactoryBot.define do
  factory :feature do
    amount { "one_dish" }
    dish_type { "japanese" }
    cooking_method { "fry" }
    main_food { "meat" }
    association :recipe
  end
end