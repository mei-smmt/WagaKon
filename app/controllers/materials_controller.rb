class MaterialsController < ApplicationController
  before_action :require_user_logged_in
  before_action -> {user_author_match(params[:recipe_id])}

  def new
    @materials = (1..10).map do
      @recipe.materials.build
    end
  end
  
  def create
    @materials = []
    materials = materials_params
    materials.each do |material|
      if material[:name].present? || material[:quantity].present?
        @materials << @recipe.materials.build(material)
      end
    end
    if Material.bulk_save(@materials)
      redirect_to new_recipe_step_path(@recipe)
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :new
    end
  end
  
  def edit
    @materials = @recipe.materials
    start = 1 + (@materials.present? ? @materials.last.id : 0)
    finish = start + 9 - @materials.size
    (start..finish).each do |i|
      @materials.build(id: i)
    end
  end
  
  def update
    @recipe.materials.destroy_all
    @materials = []
    materials = materials_params.is_a?(Array) ? materials_params : materials_params.values
    materials.each do |material|
      if material[:name].present? || material[:quantity].present?
        @materials << @recipe.materials.build(material)
      end
    end

    if Material.bulk_save(@materials)
      redirect_to edit_recipe_steps_path(@recipe)
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :edit
    end
  end

  private
    
  def materials_params
    params.permit(materials: [:name, :quantity])["materials"]
  end
end
  