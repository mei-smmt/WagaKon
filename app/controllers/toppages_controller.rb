class ToppagesController < ApplicationController
  before_action :require_user_logged_in 
  before_action :prepare_search
  before_action :set_meals

  def index
    session_clear
    @recipes = current_user.accessable_recipes
  end
  
  private
  
  def session_clear
    session[:keyword].clear if session[:keyword]
    session[:feature].clear if session[:feature]
  end
end
