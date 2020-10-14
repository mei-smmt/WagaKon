class StepsController < ApplicationController
  before_action :require_user_logged_in
  before_action -> {user_author_match(params[:article_id])}
  
  def new
    @steps = (1..2).map do
      @article.steps.build
    end
  end
  
  def create
    @steps = []
    steps_params["steps"].each do |step|
      @steps << @article.steps.build(step)
    end
    
    if Step.bulk_save(@steps)
      redirect_to root_url
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :new
    end
  end

  def edit
    @steps = @article.steps
  end
  
  def update
    @steps = @article.steps
    @steps.zip(steps_params["steps"].values) do |original_step, step|
      original_step.assign_attributes(step)
    end
    
    if Step.bulk_save(@steps)
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
