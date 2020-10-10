class MaterialsController < ApplicationController
  
  def new
    @article = Article.find(params[:id])
    @materials = (1..2).map do
      @article.materials.build
    end
  end
  
  def create
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
  
    private
    
  def materials_params
    params.permit(materials: [:name, :quantity])
  end
end
  