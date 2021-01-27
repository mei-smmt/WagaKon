module Common
  extend ActiveSupport::Concern

  def recipe_sort(recipes)
    case @sort = session[:sort]
    when 'old'
      @recipes = recipes.page(params[:page])
    when 'likes'
      recipes = recipes.sort_likes
      @recipes = Kaminari.paginate_array(recipes).page(params[:page])
    else
      recipes = recipes.sort_old
      @recipes = Kaminari.paginate_array(recipes).page(params[:page])
    end
  end
end
