class StepsController < ApplicationController
  before_action :require_user_logged_in
  before_action -> {user_author_match(params[:article_id])}
  
  def new
    @steps = (1..10).map do
      @article.steps.build
    end
  end
  
  def create
    @steps = []
    steps = steps_params["steps"]
    steps.each do |step|
      if step[:content].present? || step.has_key?(:image) 
        @steps << @article.steps.build(step)
      end
    end
    
    if Step.bulk_save(@steps)
      redirect_to preview_article_url(@article)
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :new
    end
  end

  def edit
    @steps = @article.steps
    start = @steps.last.id + 1
    finish = start + 9 - @steps.size
    (start..finish).each do |i|
      @steps.build(id: i)
    end
  end
  
  def update
    @steps = @article.steps
    new_steps = []
    steps = steps_params["steps"].values
    steps.each do |step|
      if step[:content].present? || step.has_key?(:image)
        new_steps << step
      end
    end
    
    new_steps.zip(@steps) do |new_step, step|
      if step.present? && new_step.present?
        step.assign_attributes(new_step)
      elsif new_step.present?
        @steps << @article.steps.build(new_step)
      else
        step.destroy
      end
    end

    if Step.bulk_save(@steps)
      redirect_to article_url(@article)
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
