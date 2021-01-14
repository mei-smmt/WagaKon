class MenusController < ApplicationController
  before_action :require_user_logged_in
  before_action -> {accessable_recipe_check(params[:recipe_id])}

  def create
    meal = current_user.meals.day(params[:day])
    meal.add_to_meal(@recipe)
    redirect_to recipe_url(@recipe)
  end

  def destroy
    meal = current_user.meals.day(params[:day])
    meal.remove_from_meal(@recipe)
    redirect_back(fallback_location: root_path)
  end
end
