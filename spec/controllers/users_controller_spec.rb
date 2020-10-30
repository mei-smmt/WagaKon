require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "#show" do
    before do
      @user = create(:user)
      get :show, params: {id: @user.id}
    end
    it "200レスポンスが返る" do
      expect(response.status).to eq(200)
    end
    it "@userにリクエストされたユーザーを割り当てる" do
      expect(assigns(:user)).to eq(@user)
    end
    it ':showテンプレートを表示する' do
      expect(response).to render_template :show
    end
  end
  
  describe "#new" do
    before do
      get :new
    end
    it "200レスポンスが返る" do
      expect(response.status).to eq(200)
    end
    it "@userに新しいユーザーを割り当てる" do
      expect(assigns(:user)).to be_a_new(User)
    end
    it ':newテンプレートを表示する' do
      expect(response).to render_template :new
    end
  end
  
  describe 'Post #create' do
    context '有効なパラメータの場合' do
      before do
        @user = attributes_for(:user)
      end
      it '302レスポンスが返る' do
        post :create, params:{user: @user}
        expect(response.status).to eq 302
      end
      it 'データベースに新しいユーザーが登録される' do
        expect{
          post :create, params:{user: @user}
        }.to change(User, :count).by(1)
      end
      it 'rootにリダイレクトする' do
        post :create, params:{user: @user}
        expect(response).to redirect_to root_path
      end
    end
    context '無効なパラメータの場合' do
      before do
        @invalid_user = attributes_for(:user, name: nil)
      end
      it '200レスポンスが返る' do
        post :create, params:{user: @invalid_user}
        expect(response.status).to eq 200
      end
      it 'データベースに新しいユーザーが登録されない' do
        expect{
          post :create, params:{user: @invalid_user}
        }.not_to change(User, :count)
      end
      it ':newテンプレートを再表示する' do
        post :create, params:{user: @invalid_user}
        expect(response).to render_template :new
      end
    end
  end
  
  describe "#edit" do
    context '被編集ユーザーとログインユーザーが一致' do
      before do
        @user = create(:user)
        session[:user_id] = @user.id
        get :edit, params: {id: @user.id}
      end
      it "200レスポンスが返る" do
        expect(response.status).to eq(200)
      end
      it "@userにリクエストされたユーザーを割り当てる" do
        expect(assigns(:user)).to eq(@user)
      end
      it ':editテンプレートを表示する' do
        expect(response).to render_template :edit
      end
    end
    context '被編集ユーザーとログインユーザーが一致していない' do
      before do
        @user, @login_user = create_list(:user, 2)
        session[:user_id] = @login_user.id
        get :edit, params: {id: @user.id}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it 'rootにリダイレクトする' do
        expect(response).to redirect_to root_path
      end
    end
  end
end