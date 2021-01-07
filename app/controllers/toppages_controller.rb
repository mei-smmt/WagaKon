class ToppagesController < ApplicationController
  before_action :require_user_logged_in 
  before_action :prepare_search
  before_action :prepare_meals

  def index
    recipes = current_user.accessable_recipes
    if params[:sort_order]
      if params[:sort_order] == 'old'
        @recipes = recipes.sort_old
        @select_old = true
      elsif params[:sort_order] == 'likes'
        @recipes = recipes.sort_likes
        @select_likes = true
      end
    else
      @recipes = recipes
      @select_new = true
    end
  end
end
