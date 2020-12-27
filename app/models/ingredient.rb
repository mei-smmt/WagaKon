class Ingredient < ApplicationRecord
  belongs_to :recipe

  # 材料名必須
  validates :name, presence: true, length: { maximum: 15 }
  validates :name, length: { maximum: 15 }

  # 空フォーム除外
  def self.remove_empty_form(form_ingredients)
    form_ingredients.each do |form_ingredient|
      if form_ingredient[:name].blank? && form_ingredient[:quantity].blank?
        form_ingredients.delete(form_ingredient)
      end
    end
  end

  # 材料の一括保存処理
  def self.bulk_create(recipe, ingredients, form_ingredients)
    # 空フォーム除外
    new_ingredients = Ingredient.remove_empty_form(form_ingredients)
    # 新規インスタンスを作成
    new_ingredients.each do |new_ingredient|
      ingredients << recipe.ingredients.build(new_ingredient)
    end
    all_valid = true
    # 以下、失敗したらロールバック
    Ingredient.transaction do
      ingredients.each do |ingredient|
        all_valid &= ingredient.save
      end
      unless all_valid
      # render後のフォームを補充  
        missing_forms_size = 10 - new_ingredients.size
        missing_forms_size.times do
          ingredients << recipe.ingredients.build
        end
        raise ActiveRecord::Rollback
      end
    end
    all_valid
  end

  # 材料の一括更新処理
  def self.bulk_update(recipe, form_ingredients)
    # 空フォーム除外
    new_ingredients = Ingredient.remove_empty_form(form_ingredients)
    # 仮idを設定
    temp_id = Ingredient.last.id + 1
    # 登録したいレコード数が既存レコード数より多い場合、新規インスタンスを作成
    diff = new_ingredients.size - recipe.ingredients.size
    if diff > 0
      new_ingredients.last(diff).each do |new_ingredient|
        new_ingredient.merge!(id: temp_id)
        temp_id += 1
        recipe.ingredients.build(new_ingredient)
      end
    end
    all_valid = true
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
        # render後のフォームを補充  
        missing_forms_size = 10 - new_ingredients.size
        missing_forms_size.times do
          recipe.ingredients.build(id: temp_id)
          temp_id += 1
        end
        raise ActiveRecord::Rollback
      end
    end
    all_valid
  end
end
