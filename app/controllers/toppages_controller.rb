class ToppagesController < ApplicationController
  before_action :require_user_logged_in  

  def index
    session_clear
    @recipes = current_user.accessable_recipes
  end
  
  private
  
  def session_clear
    session[:keyword].clear
    session[:feature].clear
  end
end
