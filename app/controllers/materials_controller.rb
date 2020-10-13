class MaterialsController < ApplicationController
  before_action :require_user_logged_in

  def new
    @article = Article.find(params[:id])
    @materials = (1..2).map do
      @article.materials.build
    end
  end
  
  def create
    # materials_params
    # {"materials"=>{"name"=>"rf", "quantity"=>"4"}, {"name"=>"gb", "quantity"=>"5"}}
    @article = Article.find(params[:article_id])
   
    @materials = []
    materials_params["materials"].each do |material|
      @materials << @article.materials.build(material)
    end
    
    if Material.bulk_create(@materials)
      redirect_to "/#{@article.id}/steps/new"
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :new
    end
  end
  
  def edit
    @article = Article.find(params[:id])
    @materials = @article.materials
  end
  
  def update
    # {"materials"=>{"23"=>{"name"=>"こんにちは", "quantity"=>" ２"}, "24"=>{"name"=>"アイウエオ", "quantity"=>"21"}}}
    # materials_params["materials"].values  => [{"name"=>"こんにちは", "quantity"=>" ２"}, {"name"=>"アイウエオ", "quantity"=>"21"}]
    # materials_params["materials"].keys => ["23", "24"]
    @article = Article.find(params[:article_id])
   
    @materials = @article.materials
    @materials.zip(materials_params["materials"].values) do |original_material, material|
      original_material.assign_attributes(material)
    end
    
    if Material.bulk_create(@materials)
      redirect_to "/#{@article.id}/steps/edit"
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :edit
    end
  end

    private
    
  def materials_params
    params.permit(materials: [:name, :quantity])
  end
end
  