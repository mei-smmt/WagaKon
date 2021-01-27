class ToppagesController < ApplicationController
  include Common

  before_action :require_user_logged_in
  before_action :prepare_search
  before_action :prepare_meals

  def index
    recipes = current_user.accessable_recipes
    if params[:sort_order].present?
      session[:sort] = params[:sort_order]
    else
      session[:sort]&.clear
    end
    recipe_sort(recipes)
  end
end
