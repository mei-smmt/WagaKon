class StepsController < ApplicationController
  
  def new
    @article = Article.find(params[:id])
    @steps = (1..2).map do
      @article.steps.build
    end
  end

  def edit
  end
end
