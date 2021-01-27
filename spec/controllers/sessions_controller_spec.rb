require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#new' do
    before { get :new }
    it '200レスポンスが返る' do
      expect(response.status).to eq(200)
    end
    it ':newテンプレートを表示する' do
      expect(response).to render_template :new
    end
  end
  describe 'Post #create' do
    before { @user = create(:user) }
    context 'リクエストしたユーザーが存在する場合' do
      context 'パスワードが正しい場合' do
        before do
          post :create, params: { session: { email: @user.email, password: @user.password } }
        end
        it '302レスポンスが返る' do
          expect(response.status).to eq 302
        end
        it 'ログインする' do
          expect(session[:user_id]).to eq(@user.id)
        end
        it 'rootにリダイレクトする' do
          expect(response).to redirect_to root_url
        end
      end
      context 'パスワードが正しくない場合' do
        before do
          post :create, params: { session: { email: @user.email, password: 'hoge' } }
        end
        it '200レスポンスが返る' do
          expect(response.status).to eq(200)
        end
        it 'ログインしない' do
          expect(session[:user_id]).to eq(nil)
        end
        it ':newテンプレートを再表示する' do
          expect(response).to render_template :new
        end
      end
    end
    context 'リクエストしたユーザーが存在しない場合' do
      before do
        post :create, params: { session: { email: 'hoge@example.com', password: 'hoge' } }
      end
      it '200レスポンスが返る' do
        expect(response.status).to eq(200)
      end
      it 'ログインしない' do
        expect(session[:user_id]).to eq(nil)
      end
      it ':newテンプレートを再表示する' do
        expect(response).to render_template :new
      end
    end
  end
  describe 'Delete #destroy' do
    before do
      @user = create(:user)
      session[:user_id] = @user.id
      delete :destroy
    end
    it '302レスポンスが返る' do
      expect(response.status).to eq 302
    end
    it 'ログアウトする' do
      expect(session[:user_id]).to eq(nil)
    end
    it 'rootにリダイレクトする' do
      expect(response).to redirect_to root_url
    end
  end
end
