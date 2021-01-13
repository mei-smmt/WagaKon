class ToppagesController < ApplicationController
  include Common

  before_action :require_user_logged_in 
  before_action :prepare_search
  before_action :prepare_meals

  def index
    recipes = current_user.accessable_recipes
    unless session[:sort] = params[:sort_order]
      session[:sort].clear if session[:sort]
    end
    recipe_sort(recipes)
  end
end
