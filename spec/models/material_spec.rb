require 'rails_helper'

RSpec.describe Material, type: :model do
  before do
    @material = build(:material)
  end
  
  describe 'バリデーション' do
    it 'name, quantityが入力されていればOK' do
      expect(@material.valid?).to eq(true)
    end
    
    it 'nameが空だとNG' do
      @material.name = nil
      expect(@material.valid?).to eq(false)
    end

    it 'quantityが空だとNG' do
      @material.quantity = nil
      expect(@material.valid?).to eq(false)
    end
  end
end
