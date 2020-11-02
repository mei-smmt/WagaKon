require 'rails_helper'

RSpec.describe User, type: :model do
  before do 
    @user = build(:user)
  end
  
  describe 'バリデーション' do
    it 'name,email,password,password_confirmationが入力されていればOK' do
      expect(@user.valid?).to eq(true)
    end

    it 'nameが空だとNG' do
      @user.name = nil
      expect(@user.valid?).to eq(false)
    end

    it 'emailが空だとNG' do
      @user.email = nil
      expect(@user.valid?).to eq(false)
    end
    
    it 'emailが重複するとNG' do
      @user.save
      user2 = build(:user, email: @user.email)
      expect(user2.valid?).to eq(false)
    end
    
    it 'passwordが空だとNG' do
      @user.password, @user.password_confirmation = nil, nil
      expect(@user.valid?).to eq(false)
    end
    
    it 'passwordとpassword_confirmationが一致しなければNG' do
      @user.password_confirmation = "passwood"
      expect(@user.valid?).to eq(false)
    end
    
    describe "passwordの長さ" do
      context "パスワードが4桁の時" do
        it "OK" do
          @user.password, @user.password_confirmation = "a" * 4, "a" * 4
          expect(@user.valid?).to eq(true)
        end
      end
      context "passwordが3桁の時" do
        it "NG" do
          @user.password, @user.password_confirmation = "a" * 3, "a" * 3
          expect(@user.valid?).to eq(false)
        end
      end
    end
  end
end
