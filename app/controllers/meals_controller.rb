class MealsController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @meals = current_user.meals
  end
end
