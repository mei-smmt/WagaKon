class BookmarksController < ApplicationController
before_action :require_user_logged_in

  def create
    @recipe = Recipe.find(params[:recipe_id])
    current_user.bookmark(@recipe)
    # redirect_to recipe
  end

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    current_user.unbookmark(@recipe)
    # redirect_to recipe
  end
end
