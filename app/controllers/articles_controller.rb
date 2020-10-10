class ArticlesController < ApplicationController
  def show
  end

  def new
    if logged_in?
      @article = current_user.articles.build
    end
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      redirect_to "/#{@article.id}/materials/new"
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :new
    end
  end

  def edit
  end
  
  private

  def article_params
    params.require(:article).permit(:title, :image, :explanation)
  end
  
end
