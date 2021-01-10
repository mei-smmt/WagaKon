class Feature < ApplicationRecord
  belongs_to :recipe

  with_options presence: true do
    validates :amount
    validates :dish_type
    validates :cooking_method
    validates :main_food
  end
  
  # ボリュームは？　一品もの、メイン、副菜、小鉢・おつまみ、その他
  enum amount: { one_dish: 0, main: 1, side: 2, small_side: 3, other: 4 }, _prefix: true
  # 何系料理？　和食、洋食、中華、エスニック、その他
  enum dish_type: { japanese: 0, western: 1, chinese: 2, ethnic: 3, other: 4 }, _prefix: true
  # 調理法は？　焼く・炒める、茹でる・煮る、揚げる、蒸す、加熱しない、その他
  enum cooking_method: { fry: 0, boil: 1, deep_fry: 2, steam: 3, unheated: 4, other: 5 }, _prefix: true
  # メインの食材は？　肉、魚、野菜、その他
  enum main_food: { meat: 0, fish: 1, vegetable: 2, other: 3 }, _prefix: true
end
