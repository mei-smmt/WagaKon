require 'rails_helper'

RSpec.describe Step, type: :model do
  describe 'バリデーション' do
    let(:step) { build(:step, params) }
    context 'number, contentが入力されている場合' do
      let(:params) { { number: "1", content: "野菜を切る" } }
      it 'OK' do
        expect(step.valid?).to eq(true)
      end
    end
    context 'numberが空の場合' do
      let(:params) { { number: nil, content: "野菜を切る" } }
      it 'NG' do
        expect(step.valid?).to eq(false)
      end
    end
    context 'contentが空の場合' do
      let(:params) { { number: "1", content: nil } }
      it 'NG' do
        expect(step.valid?).to eq(false)
      end
    end
  end
end
