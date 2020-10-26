require 'rails_helper'

RSpec.describe Article, type: :model do
  before do
    @article = build(:article)
  end
  
  describe 'バリデーション' do
    it 'title, image, explanation, statusが入力されていればOK' do
      expect(@article.valid?).to eq(true)
    end
    
    it 'titleが空だとNG' do
      @article.title = nil
      expect(@article.valid?).to eq(false)
    end

    it 'imageが空だとNG' do
      @article.image = nil
      expect(@article.valid?).to eq(false)
    end
    
    it 'explanationが空だとNG' do
      @article.explanation = nil
      expect(@article.valid?).to eq(false)
    end
    
    it 'statusが空だとNG' do
      @article.status = nil
      expect(@article.valid?).to eq(false)
    end
  end
end
