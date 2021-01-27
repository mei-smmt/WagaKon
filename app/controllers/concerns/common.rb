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

  def recipe_search_common(recipes)
    recipe_sort(recipes)
    prepare_submit_btn
    @count = recipes.count
  end

  def prepare_submit_btn
    @k_submit = '再検索'
    @f_submit = '絞込み'
  end
end
