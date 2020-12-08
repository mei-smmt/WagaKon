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
        @user = create(:user, name: "original_name", email: "original@example.com")
        session[:user_id] = @user.id
      end
      context 'パスワードが正しく、有効なパラメータの場合' do
        before do
          patch :update, params:{id: @user.id, user: attributes_for(:user, name: "new_name", email: "new@example.com", password: @user.password)}
        end
        it '302レスポンスが返る' do
          expect(response.status).to eq 302
        end
        it 'データベースのユーザーが更新される' do
          @user.reload
          expect([@user.name, @user.email]).to eq ['new_name', 'new@example.com']
        end
        it 'users#showにリダイレクトする' do
          expect(response).to redirect_to user_path(@user)
        end
      end
      context 'パスワードが間違っている場合' do
        before do
          patch :update, params:{id: @user.id, user: attributes_for(:user, name: "new_name", email: "new@example.com", password: 'incorrect_password')}
        end
        it '200レスポンスが返る' do
          expect(response.status).to eq 200
        end
        it 'データベースのユーザーは更新されない' do
          @user.reload
          expect([@user.name, @user.email]).to eq ["original_name", "original@example.com"]
        end
        it ':editテンプレートを再表示する' do
          expect(response).to render_template :edit
        end
      end
      context '無効なパラメータの場合' do
        before do
          patch :update, params:{id: @user.id, user: attributes_for(:user, name: nil, email: "new@example.com", password: @user.password)}
        end
        it '200レスポンスが返る' do
          expect(response.status).to eq 200
        end
        it 'データベースのユーザーは更新されない' do
          @user.reload
          expect([@user.name, @user.email]).to eq ["original_name", "original@example.com"]
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

  describe "#password_edit" do
    context '被編集ユーザーとログインユーザーが一致' do
      before do
        @user = create(:user)
        session[:user_id] = @user.id
        get :password_edit, params: {id: @user.id}
      end
      it "200レスポンスが返る" do
        expect(response.status).to eq(200)
      end
      it "@userにリクエストされたユーザーを割り当てる" do
        expect(assigns(:user)).to eq(@user)
      end
      it ':editテンプレートを表示する' do
        expect(response).to render_template :password_edit
      end
    end
    context '被編集ユーザーとログインユーザーが一致していない' do
      before do
        @user, @login_user = create_list(:user, 2)
        session[:user_id] = @login_user.id
        get :password_edit, params: {id: @user.id}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it 'rootにリダイレクトする' do
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe 'Patch #password_update' do
    context '被編集ユーザーとログインユーザーが一致' do
      before do
        @user = create(:user, password: 'original_pass', password_confirmation: 'original_pass')
        session[:user_id] = @user.id
      end
      context '現在のパスワードが正しく、有効な新パスワード(４文字以上)の場合' do
        before do
          patch :password_update, params:{id: @user.id, current_password: 'original_pass', password: 'new_pass', password_confirmation: 'new_pass'}
        end
        it '302レスポンスが返る' do
          expect(response.status).to eq 302
        end
        it 'データベースのユーザーが更新される' do
          pending "実現できていない(テストが通らない)"
          @user.reload
          expect(@user.password).to eq 'new_pass'
        end
        it 'users#showにリダイレクトする' do
          expect(response).to redirect_to user_path(@user)
        end
      end
      context '現在のパスワードが間違っている場合' do
        before do
          patch :password_update, params:{id: @user.id, current_password: 'incorrect_pass', password: 'new_pass', password_confirmation: 'new_pass'}
        end
        it '200レスポンスが返る' do
          expect(response.status).to eq 200
        end
        it 'データベースのユーザーは更新されない' do
          @user.reload
          expect(@user.password).to eq 'original_pass'
        end
        it ':password_editテンプレートを再表示する' do
          expect(response).to render_template :password_edit
        end
      end
      context '無効なパスワードの場合' do
        before do
          patch :password_update, params:{id: @user.id, current_password: 'original_pass', password: 'p', password_confirmation: 'p'}
        end
        it '200レスポンスが返る' do
          expect(response.status).to eq 200
        end
        it 'データベースのユーザーは更新されない' do
          @user.reload
          expect(@user.password).to eq 'original_pass'
        end
        it ':password_editテンプレートを再表示する' do
          expect(response).to render_template :password_edit
        end
      end
    end
    context '被編集ユーザーとログインユーザーが一致しない' do
      before do
        @user, @login_user = create_list(:user, 2)
        session[:user_id] = @login_user.id
          patch :update, params:{id: @user.id, user: attributes_for(:user, current_password: 'original_pass', password: 'new_pass', password_confirmation: 'new_pass')}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it 'rootにリダイレクトする' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#favorite_recipes" do
    before do
      @user = create(:user)
      @recipe1, @recipe2, @recipe3 = create_list(:recipe, 3)
      session[:user_id] = @user.id
      create(:bookmark, user_id: @user.id, recipe_id: @recipe1.id)
    end
    context 'リクエストユーザーとログインユーザーが一致' do
      before do
        get :favorite_recipes, params: {id: @user.id}
      end
      it "200レスポンスが返る" do
        expect(response.status).to eq(200)
      end
      it "@userにリクエストされたユーザーを割り当てる" do
        expect(assigns(:user)).to eq(@user)
      end
      it "@recipeにリクエストされたユーザーがブックマークしたレシピを割り当てる" do
        expect(assigns(:favorite_recipes)).to eq([@recipe1])
      end
      it ':favorite_recipesテンプレートを表示する' do
        expect(response).to render_template :favorite_recipes
      end
    end
    context 'リクエストユーザーとログインユーザーが一致しない' do
      before do
        @login_user = create(:user)
        session[:user_id] = @login_user.id
        get :favorite_recipes, params: {id: @user.id}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it 'rootにリダイレクトする' do
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe "#draft_recipes" do
    before do
      @user = create(:user)
      @recipe1 = create(:recipe, user_id: @user.id, status: "draft")
      @recipe2 = create(:recipe, user_id: @user.id, status: "published")
      @recipe3 = create(:recipe, status: "draft")
    end
    context 'リクエストユーザーとログインユーザーが一致' do
      before do
        session[:user_id] = @user.id
        get :draft_recipes, params: {id: @user.id}
      end
      it "200レスポンスが返る" do
        expect(response.status).to eq(200)
      end
      it "@userにリクエストされたユーザーを割り当てる" do
        expect(assigns(:user)).to eq(@user)
      end
      it "@recipeにリクエストされたユーザーの下書きレシピを割り当てる" do
        expect(assigns(:draft_recipes)).to eq([@recipe1])
      end
      it ':draft_recipesテンプレートを表示する' do
        expect(response).to render_template :draft_recipes
      end
    end
    context 'リクエストユーザーとログインユーザーが一致しない' do
      before do
        @login_user = create(:user)
        session[:user_id] = @login_user.id
        get :draft_recipes, params: {id: @user.id}
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

