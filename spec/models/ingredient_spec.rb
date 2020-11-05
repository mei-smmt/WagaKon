require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  before do
    @ingredient = build(:ingredient)
  end
  
  describe 'バリデーション' do
    it 'name, quantityが入力されていればOK' do
      expect(@ingredient.valid?).to eq(true)
    end
    
    it 'nameが空だとNG' do
      @ingredient.name = nil
      expect(@ingredient.valid?).to eq(false)
    end

    it 'quantityが空だとNG' do
      @ingredient.quantity = nil
      expect(@ingredient.valid?).to eq(false)
    end
  end
end
