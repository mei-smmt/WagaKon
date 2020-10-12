class ToppagesController < ApplicationController
  def index
    @articles = Article.all
  end
end
