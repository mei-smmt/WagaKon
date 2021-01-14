require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    let(:user) { build(:user, params) }
    context 'personal_id,name,email,password,password_confirmationが入力されている場合' do
      let(:params) {}
      it 'OK' do
        expect(user.valid?).to eq(true)
      end
    end
    context 'personal_idが空の場合' do
      let(:params) { { personal_id: nil } }
      it 'NG' do
        expect(user.valid?).to eq(false)
      end
    end
    context 'personal_idが他ユーザーと重複する場合' do
      before{ create(:user, personal_id: "test") }
      let(:params) { { personal_id: "test" } }
      it 'NG' do
        expect(user.valid?).to eq(false)
      end
    end
    context 'nameが空の場合' do
      let(:params) { { name: nil } }
      it 'NG' do
        expect(user.valid?).to eq(false)
      end
    end
    context 'emailが空の場合' do
      let(:params) { { email: nil } }
      it 'NG' do
        expect(user.valid?).to eq(false)
      end
    end
    context 'emailが他ユーザーと重複する場合' do
      before{ create(:user, email: "test@example.com") }
      let(:params) { { email: "test@example.com" } }
      it 'NG' do
        expect(user.valid?).to eq(false)
      end
    end
    context 'passwordが空の場合' do
      let(:params) { { password: nil } }
      it 'NG' do
        expect(user.valid?).to eq(false)
      end
    end
    context 'passwordとpassword_confirmationが一致しない場合' do
      let(:params) { { password: "password", password_confirmation: "ppppdddd"} }
      it 'NG' do
        expect(user.valid?).to eq(false)
      end
    end
    describe "passwordの長さ" do
      context "パスワードが4桁の場合" do
        let(:params) { { password: "p" * 4, password_confirmation: "p" * 4 } }
        it "OK" do
          expect(user.valid?).to eq(true)
        end
      end
      context "passwordが3桁の場合" do
        let(:params) { { password: "p" * 4, password_confirmation: "p" * 3 } }
        it "NG" do
          expect(user.valid?).to eq(false)
        end
      end
      context "passwordが13桁の場合" do
        let(:params) { { password: "p" * 4, password_confirmation: "p" * 13 } }
        it "NG" do
          expect(user.valid?).to eq(false)
        end
      end
    end
  end
end
