class IngredientsController < ApplicationController
  before_action :require_user_logged_in
  before_action :prepare_search
  before_action :prepare_meals
  before_action -> { user_author_match(params[:recipe_id]) }, only: %i[edit update]

  def edit
    @ingredients = @recipe.ingredients
    start = 1 + (@ingredients.present? ? @ingredients.last.id : 0)
    finish = start + INGREDIENT_MAX - @ingredients.size - 1
    (start..finish).each do |i|
      @ingredients.build(id: i)
    end
  end

  def redirect_edit
    redirect_to edit_recipe_ingredients_url(recipe_id: params[:id])
  end

  def update
    @ingredients = @recipe.ingredients
    @form_ingredients = ingredients_params.is_a?(Array) ? ingredients_params : ingredients_params.values
    # 一括更新処理呼び出し
    if Ingredient.bulk_update(@recipe, @form_ingredients)
      redirect_to edit_recipe_steps_url(@recipe)
    else
      render :edit
    end
  end

  private

  def ingredients_params
    params.permit(ingredients: %i[name quantity])['ingredients']
  end
end
