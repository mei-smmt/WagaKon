require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'バリデーション' do
    let(:recipe) { build(:recipe, params) }
    context 'title, explanation, statusが入力されてる場合' do
      let(:params) {}
      it 'OK' do
        expect(recipe.valid?).to eq(true)
      end
    end
    context 'titleが空の場合' do
      let(:params) { { title: nil } }
      it 'NG' do
        expect(recipe.valid?).to eq(false)
      end
    end
    context 'explanationが空の場合' do
      let(:params) { { explanation: nil } }
      it 'NG' do
        expect(recipe.valid?).to eq(false)
      end
    end
    context 'statusが空の場合' do
      let(:params) { { status: nil } }
      it 'NG' do
        expect(recipe.valid?).to eq(false)
      end
    end
  end
end
