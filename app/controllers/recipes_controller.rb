class RecipesController < ApplicationController
  before_action :require_user_logged_in
  before_action :prepare_search, only: [:show, :new, :edit, :keyword_search, :feature_search]
  before_action :set_meals, only: [:show, :new, :edit, :keyword_search, :feature_search]
  before_action -> {accessable_recipe_check(params[:id])}, only: :show
  before_action -> {user_author_match(params[:id])}, only: [:edit, :update, :easy_update, :destroy, :publish, :stop_publish]

  def show
  end

  def new
    @recipe = current_user.recipes.build
    @recipe.build_feature
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      redirect_to new_recipe_ingredient_url(@recipe)
    else
      render :new
    end
  end

  def easy_create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
        redirect_to recipe_url(@recipe)
    else
      render :new
    end
  end

  def edit
  end
  
  def update
    if @recipe.update(recipe_params)
      redirect_to edit_recipe_ingredients_url(@recipe)
    else
      render :edit
    end
  end
  
  def easy_update
    if @recipe.update(recipe_params)
      redirect_to recipe_url(@recipe)
    else
      render :edit
    end
  end
  
  def destroy
    @recipe.destroy
    flash[:success] = '正常に削除されました'
    redirect_to root_url
  end

  def publish
    @recipe.publishing
    redirect_to recipe_url(@recipe)
  end
  
  def stop_publish
    @recipe.drafting
    redirect_to recipe_url(@recipe)
  end
    
  def keyword_search
    @k_submit = "再検索"
    @f_submit = "絞込み"
    session[:keyword] = params[:search]
    @search_keyword = session[:keyword]
    redirect_to root_url if @search_keyword == ""
    @recipes = current_user.accessable_recipes.keyword_search(@search_keyword)
  end
  
  def feature_search
    @k_submit = "再検索"
    @f_submit = "絞込み"
    if @search_keyword = session[:keyword]
      recipes = current_user.accessable_recipes.keyword_search(@search_keyword)
      @recipes = recipes.feature_search(feature_params)
    else
      @recipes = current_user.accessable_recipes.feature_search(feature_params)
    end
    session[:feature] = feature_params
    @search_feature = session[:feature]
  end

  private

  def recipe_params
    params.require(:recipe).permit(
      :title, 
      :image, 
      :explanation,
      feature_attributes: [ :id,
                            :amount,
                            :dish_type,
                            :cooking_method,
                            :main_food])
  end
  
  def feature_params
    params.permit(:amount, :dish_type, :main_food, :cooking_method)
  end
end
