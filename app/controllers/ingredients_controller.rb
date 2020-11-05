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
    @recipe.ingredients.destroy_all
    @ingredients = []
    ingredients = ingredients_params.is_a?(Array) ? ingredients_params : ingredients_params.values
    ingredients.each do |ingredient|
      if ingredient[:name].present? || ingredient[:quantity].present?
        @ingredients << @recipe.ingredients.build(ingredient)
      end
    end

    if Ingredient.bulk_save(@ingredients)
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
  