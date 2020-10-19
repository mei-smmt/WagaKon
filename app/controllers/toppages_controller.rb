class ToppagesController < ApplicationController
  def index
    @articles = Article.published
  end
end
