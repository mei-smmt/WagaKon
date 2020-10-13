class MaterialsController < ApplicationController
  before_action :require_user_logged_in
  before_action :user_author_match

  def new
    @materials = (1..2).map do
      @article.materials.build
    end
  end
  
  def create
    # materials_params
    # {"materials"=>{"name"=>"rf", "quantity"=>"4"}, {"name"=>"gb", "quantity"=>"5"}}
    @materials = []
    materials_params["materials"].each do |material|
      @materials << @article.materials.build(material)
    end
    
    if Material.bulk_create(@materials)
      redirect_to new_article_step_path(@article)
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :new
    end
  end
  
  def edit
    @materials = @article.materials
  end
  
  def update
    # {"materials"=>{"23"=>{"name"=>"こんにちは", "quantity"=>" ２"}, "24"=>{"name"=>"アイウエオ", "quantity"=>"21"}}}
    # materials_params["materials"].values  => [{"name"=>"こんにちは", "quantity"=>" ２"}, {"name"=>"アイウエオ", "quantity"=>"21"}]
    # materials_params["materials"].keys => ["23", "24"]
    @materials = @article.materials
    @materials.zip(materials_params["materials"].values) do |original_material, material|
      original_material.assign_attributes(material)
    end
    
    if Material.bulk_create(@materials)
      redirect_to edit_article_steps_path(@article)
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :edit
    end
  end

    private
    
  def materials_params
    params.permit(materials: [:name, :quantity])
  end
  
  def user_author_match
    @article = Article.find(params[:article_id])
    @user = @article.user
    unless @user == current_user
      redirect_to root_url
    end
  end  

end
  