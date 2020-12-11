class IngredientsController < ApplicationController
  before_action :require_user_logged_in
  before_action -> {user_author_match(params[:recipe_id])}

  def new
    @ingredients = (1..10).map do
      @recipe.ingredients.build
    end
  end
  
  def create
    @ingredients = []
    ingredients = ingredients_params
    ingredients.each do |ingredient|
      if ingredient[:name].present? || ingredient[:quantity].present?
        @ingredients << @recipe.ingredients.build(ingredient)
      end
    end
    if Ingredient.bulk_save(@ingredients)
      redirect_to new_recipe_step_path(@recipe)
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :new
    end
  end
  
  def edit
    @ingredients = @recipe.ingredients
    start = 1 + (@ingredients.present? ? @ingredients.last.id : 0)
    finish = start + 9 - @ingredients.size
    (start..finish).each do |i|
      @ingredients.build(id: i)
    end
  end
  
  def update
    @ingredients = @recipe.ingredients
    @new_ingredients = ingredients_params.is_a?(Array) ? ingredients_params : ingredients_params.values
    # 空のフォームを除外
    @new_ingredients.each do |new_ingredient|
      if new_ingredient[:name].blank? && new_ingredient[:quantity].blank?
        @new_ingredients.delete(new_ingredient)
      end
    end
    # 一括更新処理呼び出し
    if Ingredient.bulk_update(@recipe, @new_ingredients)
      redirect_to edit_recipe_steps_path(@recipe)
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :edit
    end
  end
  
  private
  
  def ingredients_params
    params.permit(ingredients: [:name, :quantity])["ingredients"]
  end
end
  