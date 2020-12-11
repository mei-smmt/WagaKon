class Ingredient < ApplicationRecord
  belongs_to :recipe
  has_one :ingredient_collection
  
  # 材料名必須
  validates :name, presence: true

  # 材料の一括更新処理
  def self.bulk_update(recipe, new_ingredients)
    all_valid = true
    # 登録したいレコード数が既存レコード数より多い場合、新規インスタンスを作成
    diff = new_ingredients.size - recipe.ingredients.size
    temp_id = Ingredient.last.id + 1
    if diff > 0
      new_ingredients.last(diff).each do |new_ingredient|
        new_ingredient.merge!(id: temp_id)
        temp_id += 1
        recipe.ingredients.build(new_ingredient)
      end
    end
    # 以下、失敗したらロールバック
    Ingredient.transaction do
    　# 登録したいレコード数が既存レコード数より少ない場合、余分な既存レコードを削除
      if diff < 0
        recipe.ingredients.last(-diff).each do |ingredient|
          ingredient.destroy
        end
      end
      # 更新処理
      recipe.ingredients.zip(new_ingredients) do |prev_ingredient, new_ingredient|
        all_valid &= prev_ingredient.update(new_ingredient)
      end
      unless all_valid
        raise ActiveRecord::Rollback
      end
    end
    all_valid
  end
end
