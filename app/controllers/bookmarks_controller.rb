class BookmarksController < ApplicationController
  before_action :require_user_logged_in
  before_action -> {accessable_recipe_check(params[:recipe_id])}

  def create
    current_user.bookmark(@recipe)
  end

  def destroy
    current_user.unbookmark(@recipe)
  end
end
