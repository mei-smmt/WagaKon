require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '#show' do
    before do
      @user = create(:user)
      @friend = create(:user)
    end
    context '閲覧者がログインユーザーの友達である場合' do
      before do
        session[:user_id] = @user.id
        create(:relationship, user_id: @user.id, friend_id: @friend.id, status: 'approved')
        get :show, params: { id: @friend.id }
      end
      it '200レスポンスが返る' do
        expect(response.status).to eq(200)
      end
      it '@userにリクエストされたユーザーを割り当てる' do
        expect(assigns(:user)).to eq(@friend)
      end
      it ':showテンプレートを表示する' do
        expect(response).to render_template :show
      end
    end
    context '閲覧者がログインユーザーの友達でない場合' do
      before do
        session[:user_id] = @user.id
        get :show, params: { id: @friend.id }
      end
      it '302レスポンスが返る' do
        expect(response.status).to eq(302)
      end
      it 'rootにリダイレクトする' do
        expect(response).to redirect_to root_url
      end
    end
  end
  describe '#new' do
    before do
      get :new
    end
    it '200レスポンスが返る' do
      expect(response.status).to eq(200)
    end
    it '@userに新しいユーザーを割り当てる' do
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
        post :create, params: { user: @user }
        expect(response.status).to eq 302
      end
      it 'データベースに新しいユーザーが登録される' do
        expect do
          post :create, params: { user: @user }
        end.to change(User, :count).by(1)
      end
      it 'rootにリダイレクトする' do
        post :create, params: { user: @user }
        expect(response).to redirect_to root_url
      end
    end
    context '無効なパラメータの場合' do
      before do
        @invalid_user = attributes_for(:user, name: nil)
      end
      it '200レスポンスが返る' do
        post :create, params: { user: @invalid_user }
        expect(response.status).to eq 200
      end
      it 'データベースに新しいユーザーが登録されない' do
        expect do
          post :create, params: { user: @invalid_user }
        end.not_to change(User, :count)
      end
      it ':newテンプレートを再表示する' do
        post :create, params: { user: @invalid_user }
        expect(response).to render_template :new
      end
    end
  end
  describe '#edit' do
    before do
      @user = create(:user)
      session[:user_id] = @user.id
      get :edit
    end
    it '200レスポンスが返る' do
      expect(response.status).to eq(200)
    end
    it '@userにログインユーザーを割り当てる' do
      expect(assigns(:user)).to eq(@user)
    end
    it ':editテンプレートを表示する' do
      expect(response).to render_template :edit
    end
  end
  describe 'Patch #update' do
    before do
      @user = create(:user, name: 'orig_name', email: 'orig@example.com')
      session[:user_id] = @user.id
    end
    context 'パスワードが正しく、有効なパラメータの場合' do
      before do
        patch :update,
              params: { user: attributes_for(:user, name: 'new_name', email: 'new@example.com',
                                                    password: @user.password) }
      end
      it '302レスポンスが返る' do
        expect(response.status).to eq 302
      end
      it 'データベースのユーザーが更新される' do
        @user.reload
        expect([@user.name, @user.email]).to eq ['new_name', 'new@example.com']
      end
      it 'users#showにリダイレクトする' do
        expect(response).to redirect_to user_url(@user)
      end
    end
    context 'パスワードが間違っている場合' do
      before do
        patch :update,
              params: { user: attributes_for(:user, name: 'new_name', email: 'new@example.com',
                                                    password: 'incorrect_password') }
      end
      it '200レスポンスが返る' do
        expect(response.status).to eq 200
      end
      it 'データベースのユーザーは更新されない' do
        @user.reload
        expect([@user.name, @user.email]).to eq ['orig_name', 'orig@example.com']
      end
      it ':editテンプレートを再表示する' do
        expect(response).to render_template :edit
      end
    end
    context '無効なパラメータの場合' do
      before do
        patch :update,
              params: { user: attributes_for(:user, name: nil, email: 'new@example.com', password: @user.password) }
      end
      it '200レスポンスが返る' do
        expect(response.status).to eq 200
      end
      it 'データベースのユーザーは更新されない' do
        @user.reload
        expect([@user.name, @user.email]).to eq ['orig_name', 'orig@example.com']
      end
      it ':editテンプレートを再表示する' do
        expect(response).to render_template :edit
      end
    end
  end
  describe '#password_edit' do
    before do
      @user = create(:user)
      session[:user_id] = @user.id
      get :password_edit
    end
    it '200レスポンスが返る' do
      expect(response.status).to eq(200)
    end
    it '@userにリクエストされたユーザーを割り当てる' do
      expect(assigns(:user)).to eq(@user)
    end
    it ':editテンプレートを表示する' do
      expect(response).to render_template :password_edit
    end
  end
  describe 'Patch #password_update' do
    before do
      @user = create(:user, password: 'OrigPass', password_confirmation: 'OrigPass')
      session[:user_id] = @user.id
    end
    context '現在のパスワードが正しく、有効な新パスワード(４文字以上)の場合' do
      before do
        patch :password_update,
              params: { user: { current_password: 'OrigPass', password: 'NewPass', password_confirmation: 'NewPass' } }
      end
      it '302レスポンスが返る' do
        expect(response.status).to eq 302
      end
      it 'データベースのユーザーが更新される' do
        @user.reload
        expect(!!@user.authenticate('OrigPass')).to eq(false)
        expect(!!@user.authenticate('NewPass')).to eq(true)
      end
      it 'users#showにリダイレクトする' do
        expect(response).to redirect_to user_url(@user)
      end
    end
    context '現在のパスワードが間違っている場合' do
      before do
        patch :password_update,
              params: { user: { current_password: 'fake_pass', password: 'NewPass', password_confirmation: 'NewPass' } }
      end
      it '200レスポンスが返る' do
        expect(response.status).to eq 200
      end
      it 'データベースのユーザーは更新されない' do
        @user.reload
        expect(!!@user.authenticate('OrigPass')).to eq(true)
        expect(!!@user.authenticate('NewPass')).to eq(false)
      end
      it ':password_editテンプレートを再表示する' do
        expect(response).to render_template :password_edit
      end
    end
    context '無効なパスワードの場合' do
      before do
        patch :password_update,
              params: { user: { current_password: 'OrigPass', password: 'p', password_confirmation: 'p' } }
      end
      it '200レスポンスが返る' do
        expect(response.status).to eq 200
      end
      it 'データベースのユーザーは更新されない' do
        @user.reload
        expect(!!@user.authenticate('OrigPass')).to eq(true)
        expect(!!@user.authenticate('p')).to eq(false)
      end
      it ':password_editテンプレートを再表示する' do
        expect(response).to render_template :password_edit
      end
    end
  end
  describe '#favorite_recipes' do
    before do
      @user = create(:user)
      @friend = create(:user)
      create(:relationship, user_id: @user.id, friend_id: @friend.id, status: 'approved')
      @recipe1 = create(:recipe, status: 'published', user_id: @friend.id)
      @recipe2, @recipe3 = create_list(:recipe, 2)
      session[:user_id] = @user.id
      create(:bookmark, user_id: @user.id, recipe_id: @recipe1.id)
      create(:bookmark, user_id: @user.id, recipe_id: @recipe2.id)
    end
    before { get :favorite_recipes }
    it '200レスポンスが返る' do
      expect(response.status).to eq(200)
    end
    it '@recipeにユーザーがブックマークしたレシピを割り当てる' do
      expect(assigns(:recipes)).to eq([@recipe1])
    end
    it ':favorite_recipesテンプレートを表示する' do
      expect(response).to render_template :favorite_recipes
    end
  end
end
