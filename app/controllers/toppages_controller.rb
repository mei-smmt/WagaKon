class ToppagesController < ApplicationController
  before_action :require_user_logged_in  

  def index
    session_clear
    @recipes = current_user.accessable_recipes
    @meals = current_user.meals
  end
  
  private
  
  def session_clear
    session[:keyword].clear if session[:keyword]
    session[:feature].clear if session[:feature]
  end
end
