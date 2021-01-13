module Common
  extend ActiveSupport::Concern

  def recipe_sort(recipes)
    @sort = session[:sort]
    if @sort == "old"
      recipes = recipes.sort_old
      @recipes = Kaminari.paginate_array(recipes).page(params[:page]).per(3)
    elsif @sort == "likes"
      recipes = recipes.sort_likes
      @recipes = Kaminari.paginate_array(recipes).page(params[:page]).per(3)
    else
      @recipes = recipes.page(params[:page]).per(3)
    end
  end
end