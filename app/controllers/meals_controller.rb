class MealsController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :create, :update]
  
  def index
    @meals = current_user.meals
  end

  def show
    @meal = Meal.find(paramas[:id])
  end

  def create
  end
  
  def update
  end
end
