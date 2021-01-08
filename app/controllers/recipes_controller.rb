class RecipesController < ApplicationController
  include Common
  
  before_action :require_user_logged_in
  before_action :prepare_search, only: [:show, :new, :create, :easy_create, :edit, :update, :easy_update, :destroy, :publish, :stop_publish]
  before_action :prepare_meals
  before_action -> {accessable_recipe_check(params[:id])}, only: :show
  before_action -> {user_author_match(params[:id])}, only: [:edit, :update, :easy_update, :size_update, :destroy, :publish, :stop_publish]

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
  
  def size_update
    if @recipe.update(size_params)
      @status = "success"
    else
      @status = "fail"
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
  
  def sort
    unless session[:sort] = params[:sort_order]
      session[:sort].clear if session[:sort]
    end
    redirect_to request.referer
  end
    
  def keyword_search
    if @recipes = current_user.accessable_recipes.keyword_search(params[:search])
      recipe_sort(@recipes)
      prepare_submit_btn
      @search_feature = {}
      @search_keyword = session[:keyword] = params[:search]
    else
      redirect_to root_url
    end
  end
  
  def feature_search
    prepare_submit_btn
    @search_feature = feature_params
    if session[:keyword].present?
      @search_keyword = session[:keyword]
      recipes = current_user.accessable_recipes.keyword_search(@search_keyword)
      @recipes = recipes.feature_search(@search_feature)
    else
      @recipes = current_user.accessable_recipes.feature_search(@search_feature)
    end
    recipe_sort(@recipes)
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
  
  def size_params
    params.permit(:size)
  end
  
  def prepare_submit_btn
    @k_submit = "再検索"
    @f_submit = "絞込み"
  end  
end
