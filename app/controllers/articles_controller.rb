class ArticlesController < ApplicationController
  before_action :require_user_logged_in, only: [:new, :create, :edit]

  def show
    @article = Article.find(params[:id])
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
    @article = Article.find(params[:id])
  end
  
  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to "/#{@article.id}/materials/edit"
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :edit
    end
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    flash[:success] = '正常に削除されました'
    redirect_to root_url
  end
    
  private

  def article_params
    params.require(:article).permit(:title, :image, :explanation)
  end
  
end
