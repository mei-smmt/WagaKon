class ReloadsController < ApplicationController
  before_action :require_user_logged_in
  before_action :prepare_search
  before_action :prepare_meals
  before_action -> { accessable_recipe_check(params[:id]) }, only: %i[recipe_show]

  def recipe_show
    redirect_to recipe_url(@recipe)
  end

  def recipe_new
    redirect_to new_recipes_url
  end

  def ingredients_edit
    redirect_to edit_recipe_ingredients_url(recipe_id: params[:id])
  end

  def steps_edit
    redirect_to edit_recipe_steps_url(recipe_id: params[:id])
  end
end
