require 'rails_helper'

RSpec.describe Recipe, type: :model do
  before do
    @recipe = build(:recipe)
  end
  
  describe 'バリデーション' do
    it 'title, explanation, statusが入力されていればOK' do
      expect(@recipe.valid?).to eq(true)
    end
    
    it 'titleが空だとNG' do
      @recipe.title = nil
      expect(@recipe.valid?).to eq(false)
    end

    it 'explanationが空だとNG' do
      @recipe.explanation = nil
      expect(@recipe.valid?).to eq(false)
    end
    
    it 'statusが空だとNG' do
      @recipe.status = nil
      expect(@recipe.valid?).to eq(false)
    end
  end
end
