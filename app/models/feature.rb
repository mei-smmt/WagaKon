class Feature < ApplicationRecord
  validates :amount, presence: true
  validates :type, presence: true
  validates :cooking_method, presence: true
  validates :main_food, presence: true
  
  enum amount: { one_dish: 0, main: 1, side: 2, small_side: 3, other: 4 }, _prefix: true
  enum type: { japanese: 0, western: 1, chinese: 2, ethnic: 3, other: 4 }, _prefix: true
  enum cooking_method: { fry: 0, boil: 1, deep_fry: 2, steam: 3, unheated: 4, other: 5 }, _prefix: true
  enum main_food: { meat: 0, fish: 1, vegetable: 2, other: 3 }, _prefix: true
  
  belongs_to :recipe
end
