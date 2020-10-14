class BookmarksController < ApplicationController
before_action :require_user_logged_in

  def create
    article = Article.find(params[:article_id])
    current_user.bookmark(article)
    redirect_to article
  end

  def destroy
    article = Article.find(params[:article_id])
    current_user.unbookmark(article)
    redirect_to article
  end
end
