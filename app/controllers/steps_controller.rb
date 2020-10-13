class StepsController < ApplicationController
  before_action :require_user_logged_in
  
  def new
    @article = Article.find(params[:article_id])
    @steps = (1..2).map do
      @article.steps.build
    end
  end
  
  def create
    @article = Article.find(params[:article_id])
   
    @steps = []
    steps_params["steps"].each do |step|
      @steps << @article.steps.build(step)
    end
    
    if Step.bulk_create(@steps)
      redirect_to root_url
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :new
    end
  end

  def edit
    @article = Article.find(params[:article_id])
    @steps = @article.steps
  end
  
  def update
    @article = Article.find(params[:article_id])
   
    @steps = @article.steps
    @steps.zip(steps_params["steps"].values) do |original_step, step|
      original_step.assign_attributes(step)
    end
    
    if Step.bulk_create(@steps)
      redirect_to root_url
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :edit
    end
  end
  
  private
  
  def steps_params
    params.permit(steps: [:number, :image, :content])
  end

end
