class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  # ログイン要求
  def require_user_logged_in
    redirect_to login_url unless logged_in?
  end

  # ログイン処理
  def login(email, password)
    @user = User.find_by(email: email)
    if @user&.authenticate(password)
      # ログイン成功
      session[:user_id] = @user.id
      true
    else
      # ログイン失敗
      false
    end
  end

  # レシピ作成者本人であることの確認
  def user_author_match(recipe_id)
    @recipe = Recipe.find(recipe_id)
    @user = @recipe.user
    redirect_to root_url unless @user == current_user
  end

  # レシピへのアクセス権確認（本人or友だち？）
  def accessable_recipe_check(recipe_id)
    @recipe = Recipe.find(recipe_id)
    redirect_to root_url unless current_user.accessable_recipes.include?(@recipe)
  end

  # レシピ検索サイドバー表示の準備
  def prepare_search
    session[:sort]&.clear
    session[:keyword]&.clear
    @search_keyword = nil
    @search_feature = {}
    @k_submit = '検索'
    @f_submit = '検索'
  end

  # 献立Listサイドバー表示の準備
  def prepare_meals
    @meals = current_user.meals
  end
end
