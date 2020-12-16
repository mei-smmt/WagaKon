class RecipesController < ApplicationController
  before_action :require_user_logged_in, only: [:new, :create]
  before_action -> {user_author_match(params[:id])}, only: [:edit, :update, :destroy, :preview, :publish, :stop_publish]

  def show
    @recipe = Recipe.find(params[:id])
    if @recipe.status == "draft"
      redirect_to preview_recipe_url(@recipe)
    end
  end

  def new
    if logged_in?
      @recipe = current_user.recipes.build
      @recipe.build_feature
    end
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      redirect_to new_recipe_ingredient_path(@recipe)
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :new
    end
  end

  def edit
  end
  
  def update
    if @recipe.update(recipe_params)
      redirect_to edit_recipe_ingredients_path(@recipe)
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :edit
    end
  end
  
  def destroy
    @recipe.destroy
    flash[:success] = '正常に削除されました'
    redirect_to root_url
  end
  
  def preview
  end
  
  def publish
    @recipe.publishing
    redirect_to recipe_url(@recipe)
  end
  
  def stop_publish
    @recipe.drafting
    redirect_to draft_recipes_user_url(@user)
  end
    
  def search
    redirect_to root_url if params[:search] == ""
    @recipes = Recipe.published.search(params[:search])
  end
    
  private

  def recipe_params
    params.require(:recipe).permit(
      :title, 
      :image, 
      :explanation,
      feature_attributes: [ :id,
                            :amount,
                            :type,
                            :cooking_method,
                            :main_food])
  end
end
