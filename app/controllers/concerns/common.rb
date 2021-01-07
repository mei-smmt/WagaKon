module Common
  extend ActiveSupport::Concern

  def recipe_sort(recipes)
    @sort = session[:sort]
    if @sort == "old"
      @recipes = recipes.sort_old
    elsif @sort == "likes"
      @recipes = recipes.sort_likes
    end
  end
end