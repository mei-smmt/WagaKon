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
    @new_ingredients = ingredients_params
    # 空フォーム除外
    Ingredient.remove_empty_form(@new_ingredients)
    # 新規インスタンスを作成
    @new_ingredients.each do |new_ingredient|
        @ingredients << @recipe.ingredients.build(new_ingredient)
    end
    # 一括保存処理呼び出し
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
    # 空フォーム除外
    Ingredient.remove_empty_form(@new_ingredients)
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
  