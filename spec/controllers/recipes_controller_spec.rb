require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  before do
    @user = create(:user)
  end
  describe "#show" do
    before do
      @friend = create(:user)
      create(:relationship, user_id: @user.id, friend_id: @friend.id, status: 'approved')
    end
    context 'ログイン済みの場合' do
      before { session[:user_id] = @user.id }
      context 'リクエストしたレシピのstatusが「公開」の場合' do
        before do
          @recipe = create(:recipe, status: "published", user_id: @friend.id)
          get :show, params: {id: @recipe.id}
        end
        it "200レスポンスが返る" do
          expect(response.status).to eq(200)
        end
        it "@recipeにリクエストされたレシピを割り当てる" do
          expect(assigns(:recipe)).to eq(@recipe)
        end
        it ':showテンプレートを表示する' do
          expect(response).to render_template :show
        end
      end
      context 'リクエストしたレシピのstatusが「非公開」の場合' do
        before do
          @recipe = create(:recipe, status: "draft", user_id: @friend.id)
          get :show, params: {id: @recipe.id}
        end
        it "302レスポンスが返る" do
          expect(response.status).to eq(302)
        end
        it ':rootにリダイレクトする' do
          expect(response).to redirect_to root_path
        end
      end
    end
    context "ログインなしの場合" do
      before do
        @recipe = create(:recipe, status: "published", user_id: @friend.id)
        session[:user_id] = nil
        get :show, params: {id: @recipe.id}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        expect(response).to redirect_to login_url
      end
    end
  end
  describe "#new" do
    context "ログイン済みの場合" do
      before do
        session[:user_id] = @user.id
        get :new
      end
      it "200レスポンスが返る" do
        expect(response.status).to eq(200)
      end
      it "@recipeに新しいレシピを割り当てる" do
        expect(assigns(:recipe)).to be_a_new(Recipe)
      end
      it ':newテンプレートを表示する' do
        expect(response).to render_template :new
      end
    end
    context "ログインなしの場合" do
      before do
        session[:user_id] = nil
        get :new
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        expect(response).to redirect_to login_url
      end
    end
  end
  describe 'Post #create' do
    context 'ログイン済みの場合' do
      before { session[:user_id] = @user.id }
      context '有効なパラメータの場合' do
        before { @recipe = attributes_for(:recipe) }
        it '302レスポンスが返る' do
          post :create, params:{recipe: @recipe}
          expect(response.status).to eq 302
        end
        it 'データベースにユーザーの新しいレシピが登録される' do
          expect{
            post :create, params:{recipe: @recipe}
          }.to change(@user.recipes, :count).by(1)
        end
        it '材料入力画面にリダイレクトする' do
          post :create, params:{recipe: @recipe}
          expect(response).to redirect_to edit_recipe_ingredients_url(@user.recipes.last)
        end
      end
      context '無効なパラメータの場合' do
        before do
          @invalid_recipe = attributes_for(:recipe, title: nil)
        end
        it '200レスポンスが返る' do
          post :create, params:{recipe: @invalid_recipe}
          expect(response.status).to eq 200
        end
        it 'データベースに新しいレシピが登録されない' do
          expect{
            post :create, params:{recipe: @invalid_recipe}
          }.not_to change(@user.recipes, :count)
        end
        it ':newテンプレートを再表示する' do
          post :create, params:{recipe: @invalid_recipe}
          expect(response).to render_template :new
        end
      end
    end
    context "ログインなしの場合" do
      before do
        session[:user_id] = nil
        post :create, params:{recipe: @recipe}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        expect(response).to redirect_to login_url
      end
    end
  end
  describe "#edit" do
    before { @recipe = create(:recipe, user_id: @user.id) }
    context 'ログイン済みの場合' do
      context 'レシピ作者とログインユーザーが一致する場合' do
        before do
          session[:user_id] = @user.id
          get :edit, params: {id: @recipe.id}
        end
        it "200レスポンスが返る" do
          expect(response.status).to eq(200)
        end
        it "@recipeにリクエストされたレシピを割り当てる" do
          expect(assigns(:recipe)).to eq(@recipe)
        end
        it ':editテンプレートを表示する' do
          expect(response).to render_template :edit
        end
      end
      context 'レシピ作者とログインユーザーが一致しない場合' do
        before do
          @login_user = create(:user)
          session[:user_id] = @login_user.id
          get :edit, params: {id: @recipe.id}
        end
        it "302レスポンスが返る" do
          expect(response.status).to eq(302)
        end
        it 'rootにリダイレクトする' do
          expect(response).to redirect_to root_url
        end
      end
    end
    context "ログインなしの場合" do
      before do
        session[:user_id] = nil
        get :edit, params: {id: @recipe.id}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        expect(response).to redirect_to login_url
      end
    end
  end
  describe 'Patch #update' do
    before { @recipe = create(:recipe, user_id: @user.id, title: "orig_title") }
    context 'ログイン済みの場合' do
      context 'レシピ作者とログインユーザーが一致する場合' do
        before do
          session[:user_id] = @user.id
        end
        context '有効なパラメータの場合' do
          before do
            patch :update, params:{id: @recipe.id, recipe: attributes_for(:recipe, title: "new_title")}
          end
          it '302レスポンスが返る' do
            expect(response.status).to eq 302
          end
          it 'データベースのレシピが更新される' do
            @recipe.reload
            expect(@recipe.title).to eq 'new_title'
          end
          it '材料編集画面にリダイレクトする' do
            expect(response).to redirect_to edit_recipe_ingredients_url(@recipe)
          end
        end
        context '無効なパラメータの場合' do
          before do
            patch :update, params:{id: @recipe.id, recipe: attributes_for(:recipe, title: nil)}
          end
          it '200レスポンスが返る' do
            expect(response.status).to eq 200
          end
          it 'データベースのユーザーは更新されない' do
            @recipe.reload
            expect(@recipe.title).to eq "orig_title"
          end
          it ':editテンプレートを再表示する' do
            expect(response).to render_template :edit
          end
        end
      end
      context 'レシピ作者とログインユーザーが一致しない場合' do
        before do
          @login_user = create(:user)
          session[:user_id] = @login_user.id
          patch :update, params:{id: @recipe.id, recipe: attributes_for(:recipe, title: "new_title")}
        end
        it "302レスポンスが返る" do
          expect(response.status).to eq(302)
        end
        it 'rootにリダイレクトする' do
          expect(response).to redirect_to root_url
        end
      end
    end
    context "ログインなしの場合" do
      before do
        session[:user_id] = nil
        patch :update, params:{id: @recipe.id, recipe: attributes_for(:recipe, title: nil)}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        expect(response).to redirect_to login_url
      end
    end
  end
  describe "Delete #destroy" do
    before { @recipe = create(:recipe, user_id: @user.id) }
    context 'ログイン済みの場合' do
      context 'レシピ作者とログインユーザーが一致する場合' do
        before do
          session[:user_id] = @user.id
        end
        it '302レスポンスが返る' do
          delete :destroy, params: {id: @recipe.id}
          expect(response.status).to eq 302
        end
        it 'データベースからユーザーのレシピが削除される' do
          expect{
            delete :destroy, params: {id: @recipe.id}
          }.to change(@user.recipes, :count).by(-1)
        end
        it 'rootにリダイレクトする' do
          delete :destroy, params: {id: @recipe.id}
          expect(response).to redirect_to root_url
        end
      end
      context 'レシピ作者とログインユーザーが一致しない場合' do
        before do
          @login_user = create(:user)
          session[:user_id] = @login_user.id
        end
        it "302レスポンスが返る" do
          delete :destroy, params: {id: @recipe.id}
          expect(response.status).to eq(302)
        end
        it 'データベースからユーザーのレシピは削除されない' do
          expect{
            delete :destroy, params: {id: @recipe.id}
          }.not_to change(@user.recipes, :count)
        end
        it 'rootにリダイレクトする' do
          delete :destroy, params: {id: @recipe.id}
          expect(response).to redirect_to root_url
        end
      end
    end
    context "ログインなしの場合" do
      before do
        session[:user_id] = nil
        delete :destroy, params: {id: @recipe.id}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        expect(response).to redirect_to login_url
      end
    end
  end
  describe 'Patch #publish' do
    before { @recipe = create(:recipe, user_id: @user.id, status: "draft") }
    context 'ログイン済みの場合' do
      context 'レシピ作者とログインユーザーが一致する場合' do
        before do
          session[:user_id] = @user.id
          patch :publish, params:{id: @recipe.id, recipe: attributes_for(:recipe, status: "published")}
        end
        it '302レスポンスが返る' do
          expect(response.status).to eq 302
        end
        it 'データベースのレシピが更新される' do
          @recipe.reload
          expect(@recipe.status).to eq 'published'
        end
        it 'レシピ詳細画面にリダイレクトする' do
          expect(response).to redirect_to recipe_url(@recipe)
        end
      end
      context 'レシピ作者とログインユーザーが一致しない場合' do
        before do
          @login_user = create(:user)
          session[:user_id] = @login_user.id
          patch :publish, params:{id: @recipe.id, recipe: attributes_for(:recipe, status: "published")}
        end
        it "302レスポンスが返る" do
          expect(response.status).to eq(302)
        end
        it 'データベースのレシピは更新されない' do
          @recipe.reload
          expect(@recipe.status).to eq "draft"
        end
        it 'rootにリダイレクトする' do
          expect(response).to redirect_to root_url
        end
      end
    end
    context "ログインなしの場合" do
      before do
        session[:user_id] = nil
        patch :publish, params:{id: @recipe.id, recipe: attributes_for(:recipe, status: "published")}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        expect(response).to redirect_to login_url
      end
    end
  end
  describe 'Patch #stop_publish' do
    before { @recipe = create(:recipe, user_id: @user.id, status: "published") }
    context 'ログイン済みの場合' do
      context 'レシピ作者とログインユーザーが一致する場合' do
        before do
          session[:user_id] = @user.id
          patch :stop_publish, params:{id: @recipe.id, recipe: attributes_for(:recipe, status: "draft")}
        end
        it '302レスポンスが返る' do
          expect(response.status).to eq 302
        end
        it 'データベースのレシピが更新される' do
          @recipe.reload
          expect(@recipe.status).to eq 'draft'
        end
        it ':showにリダイレクトする' do
          expect(response).to redirect_to recipe_url(@recipe)
        end
      end
      context 'レシピ作者とログインユーザーが一致しない場合' do
        before do
          @login_user = create(:user)
          session[:user_id] = @login_user.id
          patch :stop_publish, params:{id: @recipe.id, recipe: attributes_for(:recipe, status: "draft")}
        end
        it "302レスポンスが返る" do
          expect(response.status).to eq(302)
        end
        it 'データベースのレシピは更新されない' do
          @recipe.reload
          expect(@recipe.status).to eq "published"
        end
        it 'rootにリダイレクトする' do
          expect(response).to redirect_to root_url
        end
      end
    end
    context "ログインなしの場合" do
      before do
        session[:user_id] = nil
        patch :stop_publish, params:{id: @recipe.id, recipe: attributes_for(:recipe, status: "draft")}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        expect(response).to redirect_to login_url
      end
    end
  end
  describe "検索機能" do
    before do
      @friend = create(:user)
      create(:relationship, user_id: @user.id, friend_id: @friend.id, status: 'approved')
      session[:user_id] = @user.id
    end
    describe "#keyword_search" do
      before do
        @recipe_published = create(:recipe, status: "published", title: "オクラの胡麻和え", explanation: "とてもおいしいです。", user_id: @friend.id)
        @recipe_draft = create(:recipe, status: "draft", title: "ほうれん草のお浸し", explanation: "おいしいよ。", user_id: @friend.id)
      end
      context '検索ワードが入力されている場合' do
        context '検索ワードの全てが"title" または "explanation"に含まれている場合' do
          before { get :keyword_search, params: {search: "オクラ　おいしい"} }
          it "200レスポンスが返る" do
            expect(response.status).to eq(200)
          end
          it "@recipesに下書きレシピは登録されない" do
            expect(assigns(:recipes)).to eq([@recipe_published])
          end
          it ':keyword_searchテンプレートを表示する' do
            expect(response).to render_template :keyword_search
          end
        end
        context '検索ワードが一つでも"title"か"explanation"に含まれていない場合' do
          before { get :keyword_search, params: {search: "オクラ　炒める"} }
          it "200レスポンスが返る" do
            expect(response.status).to eq(200)
          end
          it "@recipesにレシピが割り当てられない" do
            expect(assigns(:recipes)).to eq([])
          end
          it ':keyword_searchテンプレートを表示する' do
            expect(response).to render_template :keyword_search
          end
        end
      end
      context '検索ワードが入力されていない場合' do
        before { get :keyword_search, params: {search: ""} }
        it "302レスポンスが返る" do
          expect(response.status).to eq(302)
        end
        it 'rootにリダイレクトする' do
          expect(response).to redirect_to root_url
        end
      end
    end
    describe "#feature_search" do
      before do
        @recipe_published = create(:recipe, status: "published", user_id: @friend.id)
        create(:feature, recipe_id: @recipe_published.id, cooking_method: 'fry')
        @recipe_draft = create(:recipe, status: "draft", user_id: @friend.id)
        create(:feature, recipe_id: @recipe_draft.id, cooking_method: 'fry')
      end
      context '検索条件に一致する場合' do
        before { get :feature_search, params: {cooking_method: 'fry'} }
        it "200レスポンスが返る" do
          expect(response.status).to eq(200)
        end
        it "@recipesに該当するレシピが登録される" do
          expect(assigns(:recipes)).to eq([@recipe_published])
        end
        it ':keyword_searchテンプレートを表示する' do
          expect(response).to render_template :feature_search
        end
      end
      context '検索条件に一致しない場合' do
        before { get :feature_search, params: {cooking_method: 'boil'} }
        it "200レスポンスが返る" do
          expect(response.status).to eq(200)
        end
        it "@recipesにレシピが割り当てられない" do
          expect(assigns(:recipes)).to eq([])
        end
        it ':feature_searchテンプレートを表示する' do
          expect(response).to render_template :feature_search
        end
      end
    end
  end
end