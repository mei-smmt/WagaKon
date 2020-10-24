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
    steps = steps_params
    steps.each do |step|
      if step[:content].present?
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
    start = 1 + (@steps.present? ? @steps.last.id : 0)
    finish = start + 9 - @steps.size
    (start..finish).each do |i|
      @steps.build(id: i)
    end
  end
  
  def update
    @article.steps.destroy_all
    @steps = []
    steps = steps_params.is_a?(Array) ? steps_params : steps_params.values
    steps.each do |step|
      if step[:content].present?
        @steps << @article.steps.build(step)
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
    params.permit(steps: [:number, :content])["steps"]
  end
end
