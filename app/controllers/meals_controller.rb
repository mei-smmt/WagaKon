class MealsController < ApplicationController
  before_action :require_user_logged_in
  before_action :prepare_search
  before_action :prepare_meals
  
  def index
  end
end
