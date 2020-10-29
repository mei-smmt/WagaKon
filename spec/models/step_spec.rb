require 'rails_helper'

RSpec.describe Step, type: :model do
  before do
    @step = build(:step)
  end
  
  describe 'バリデーション' do
    it 'number, contentが入力されていればOK' do
      expect(@step.valid?).to eq(true)
    end
    
    it 'numberが空だとNG' do
      @step.number = nil
      expect(@step.valid?).to eq(false)
    end

    it 'contentが空だとNG' do
      @step.content = nil
      expect(@step.valid?).to eq(false)
    end
  end
end
