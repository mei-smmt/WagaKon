require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  before do
    @ingredient = build(:ingredient)
  end
  
  describe 'バリデーション' do
    it 'nameが入力されていればOK' do
      @ingredient.quantity = nil
      expect(@ingredient.valid?).to eq(true)
    end
    
    it 'nameが空だとNG' do
      @ingredient.name = nil
      expect(@ingredient.valid?).to eq(false)
    end
  end
end
