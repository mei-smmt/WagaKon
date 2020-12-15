class MenusController < ApplicationController
before_action :require_user_logged_in

  def create
    @recipe = Recipe.find(params[:recipe_id])
    meal = current_user.meals.day(params[:day])
    meal.add_to_meal(@recipe)
    redirect_to recipe
  end

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    meal = current_user.meals.day(params[:day])
    meal.remove_from_meal(@recipe)
    redirect_to recipe
  end
end
