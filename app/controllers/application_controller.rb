class ApplicationController < ActionController::Base
  
  include SessionsHelper
  
   private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def login(email, password)
    @user = User.find_by(email: email)
    if @user && @user.authenticate(password)
      # ログイン成功
      session[:user_id] = @user.id
      return true
    else
      # ログイン失敗
      return false
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
  
  def prepare_search
    @search_keyword = nil
    @search_feature = {}
    @k_submit = "検索"
    @f_submit = "検索"
  end
  
  def set_meals
    @meals = current_user.meals
  end
end
