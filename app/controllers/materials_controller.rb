class MaterialsController < ApplicationController
  before_action :require_user_logged_in
  before_action -> {user_author_match(params[:article_id])}

  def new
    @materials = (1..10).map do
      @article.materials.build
    end
  end
  
  def create
    @materials = []
    materials = materials_params["materials"]
    materials.each do |material|
      if material[:name].present? || material[:quantity].present?
        @materials << @article.materials.build(material)
      end
    end
    
    if Material.bulk_save(@materials)
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
    @materials = @article.materials
    @materials.zip(materials_params["materials"].values) do |original_material, material|
      original_material.assign_attributes(material)
    end
    
    if Material.bulk_save(@materials)
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
end
  