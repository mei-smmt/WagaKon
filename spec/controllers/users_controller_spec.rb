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
  
  describe 'Patch #update' do
    context '被編集ユーザーとログインユーザーが一致' do
      before do
        @user = create(:user)
        @originalname = @user.name
        session[:user_id] = @user.id
      end
      context '有効なパラメータの場合' do
        before do
          patch :update, params:{id: @user.id, user: attributes_for(:user, name: "new_name")}
        end
        it '302レスポンスが返る' do
          expect(response.status).to eq 302
        end
        it 'データベースのユーザーが更新される' do
          @user.reload
          expect(@user.name).to eq 'new_name'
        end
        it 'users#showにリダイレクトする' do
          expect(response).to redirect_to user_path(@user)
        end
      end
      context '無効なパラメータの場合' do
        before do
          patch :update, params:{id: @user.id, user: attributes_for(:user, name: nil)}
        end
        it '200レスポンスが返る' do
          expect(response.status).to eq 200
        end
        it 'データベースのユーザーは更新されない' do
          @user.reload
          expect(@user.name).to eq @originalname
        end
        it ':editテンプレートを再表示する' do
          expect(response).to render_template :edit
        end
      end
    end
    context '被編集ユーザーとログインユーザーが一致しない' do
      before do
        @user, @login_user = create_list(:user, 2)
        session[:user_id] = @login_user.id
        patch :update, params:{id: @user.id, user: attributes_for(:user, name: "new_name")}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it 'rootにリダイレクトする' do
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe "#favorite_articles" do
    before do
      @user = create(:user)
      @article1, @article2, @article3 = create_list(:article, 3)
      session[:user_id] = @user.id
      create(:bookmark, user_id: @user.id, article_id: @article1.id)
    end
    context 'リクエストユーザーとログインユーザーが一致' do
      before do
        get :favorite_articles, params: {id: @user.id}
      end
      it "200レスポンスが返る" do
        expect(response.status).to eq(200)
      end
      it "@userにリクエストされたユーザーを割り当てる" do
        expect(assigns(:user)).to eq(@user)
      end
      it "@articleにリクエストされたユーザーがブックマークした記事を割り当てる" do
        expect(assigns(:favorite_articles)).to eq([@article1])
      end
      it ':favorite_articlesテンプレートを表示する' do
        expect(response).to render_template :favorite_articles
      end
    end
    context 'リクエストユーザーとログインユーザーが一致しない' do
      before do
        @login_user = create(:user)
        session[:user_id] = @login_user.id
        get :favorite_articles, params: {id: @user.id}
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

