class Ingredient < ApplicationRecord
  belongs_to :recipe

  # 材料名必須
  validates :name, presence: true, length: { maximum: 15 }, lt4bytes: true
  validates :quantity, length: { maximum: 10 }, lt4bytes: true

  # 空フォーム除外
  def self.remove_empty_form(form_ingredients)
    form_ingredients.each do |form_ingredient|
      form_ingredients.delete(form_ingredient) if form_ingredient[:name].blank? && form_ingredient[:quantity].blank?
    end
  end

  # フォーム補充
  def self.refill_form(new_ingredients, recipe, temp_id)
    missing_forms_size = INGREDIENT_MAX - new_ingredients.size
    missing_forms_size.times do
      recipe.ingredients.build(id: temp_id)
      temp_id += 1
    end
  end

  def self.bulk_update(recipe, form_ingredients)
    new_ingredients = Ingredient.remove_empty_form(form_ingredients)
    # 仮idを設定
    temp_id = Ingredient.last.present? ? Ingredient.last.id + 1 : 1
    # 登録したいレコード数が既存レコード数より多い場合、新規インスタンスを作成
    diff = new_ingredients.size - recipe.ingredients.size
    if diff.positive?
      new_ingredients.last(diff).each do |new_ingredient|
        new_ingredient.merge!(id: temp_id)
        recipe.ingredients.build(new_ingredient)
        temp_id += 1
      end
    end
    all_valid = true
    Ingredient.transaction do
      # 登録したいレコード数が既存レコード数より少ない場合、余分な既存レコードを削除
      recipe.ingredients.last(-diff).each(&:destroy) if diff.negative?
      # 更新処理
      recipe.ingredients.zip(new_ingredients) do |prev_ingredient, new_ingredient|
        all_valid &= prev_ingredient.update(new_ingredient)
      end
      unless all_valid
        Ingredient.refill_form(new_ingredients, recipe, temp_id)
        raise ActiveRecord::Rollback
      end
    end
    all_valid
  end
end
