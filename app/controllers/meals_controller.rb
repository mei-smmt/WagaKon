class MealsController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]
  
  def index
    @meals = current_user.meals
  end

  def show
    @meal = Meal.find(paramas[:id])
  end
end
