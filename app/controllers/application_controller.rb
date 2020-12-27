class ApplicationController < ActionController::Base
  
  include SessionsHelper
  
   private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def user_author_match(recipe_id)
    @recipe = Recipe.find(recipe_id)
    @user = @recipe.user
    unless @user == current_user
      redirect_to root_url
    end
  end
  
  def accessable_recipe_check(recipe_id)
    @recipe = Recipe.find(recipe_id)
    unless current_user.accessable_recipes.include?(@recipe)
      redirect_to root_url
    end
  end
end
