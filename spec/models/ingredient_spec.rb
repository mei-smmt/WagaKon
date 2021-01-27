require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  describe 'バリデーション' do
    let(:ingredient) { build(:ingredient, params) }
    context 'nameが入力されている場合' do
      let(:params) {}
      it 'OK' do
        expect(ingredient.valid?).to eq(true)
      end
    end
    context 'nameが空の場合' do
      let(:params) { { name: nil, quantity: '二個' } }
      it 'NG' do
        expect(ingredient.valid?).to eq(false)
      end
    end
  end
end
