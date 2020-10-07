class MaterialsController < ApplicationController
  
  def new
    @article = Article.find(params[:id])
    @material = @article.materials.build
  end
  
  def create
    @article = Article.find(params[:article_id])
    @material = @article.materials.build(material_params)
    if @material.save
      redirect_to root_url
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :new
    end
  end
  
    private

  def material_params
    params.require(:material).permit(:name, :quantity)
  end

end
