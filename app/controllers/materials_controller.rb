class MaterialsController < ApplicationController
  
  def new
    @article = Article.find(params[:id])
    @materials = (1..10).map do
      @article.materials.build
    end
  end
  
  def create
    @article = Article.find(params[:article_id])
    
    @materials = (1..10).map do
      @article.materials.build
    end
    
    materials_require.each_with_index do |material_require, index|
      material_params = material_require.permit(:name, :quantity)
      @materials[index] = @article.materials.new(material_params)
    end

    is_success = true
    @materials.each do |material|
      is_success = false unless material.save
    end
      
    if is_success == true
      redirect_to root_url
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :new
    end
  end
  
    private
    
  def materials_require
    params.require(:materials)
  end

end

# materials_params -> requireを消す
# save失敗したときの処理　transaction, rescue
# 空の配列定義
# 要素の追加　<<