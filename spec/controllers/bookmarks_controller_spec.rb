require 'rails_helper'

RSpec.describe BookmarksController, type: :controller do
  describe "Post #create" do
    before do
      include SessionsHelper
      @user = create(:user)
      @recipe = create(:recipe)
    end
    context "ログイン済み" do
      before do
        session[:user_id] = @user.id
      end
      context "同じ条件のブックマークが存在しない" do
        it '302レスポンスが返る' do
          post :create, params:{recipe_id: @recipe.id}
          expect(response.status).to eq 302
        end
        it 'データベースにユーザーの新しいブックマークが登録される' do
          expect{
            post :create, params:{recipe_id: @recipe.id}
          }.to change(@user.bookmarks, :count).by(1)
        end
        it 'データベースに記事の新しいブックマークが登録される' do
          expect{
            post :create, params:{recipe_id: @recipe.id}
          }.to change(@recipe.bookmarks, :count).by(1)
        end
        it "記事詳細にリダイレクトする" do
          post :create, params:{recipe_id: @recipe.id}
          expect(response).to redirect_to recipe_path(@recipe)
        end
      end
      context "既に同じ条件のブックマークが存在する" do
        before do 
          create(:bookmark, user_id: @user.id, recipe_id: @recipe.id)
        end
        it '302レスポンスが返る' do
          post :create, params:{recipe_id: @recipe.id}
          expect(response.status).to eq 302
        end
        it 'データベースにユーザーの新しいブックマークが登録されない' do
          expect{
            post :create, params:{recipe_id: @recipe.id}
          }.not_to change(@user.bookmarks, :count)
        end
        it 'データベースに記事の新しいブックマークが登録されない' do
          expect{
            post :create, params:{recipe_id: @recipe.id}
          }.not_to change(@recipe.bookmarks, :count)
        end
        it "記事詳細にリダイレクトする" do
          post :create, params:{recipe_id: @recipe.id}
          expect(response).to redirect_to recipe_path(@recipe)
        end
      end
    end
    context "ログインなし" do
      it "302レスポンスが返る" do
        post :create, params:{recipe_id: @recipe.id}
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        post :create, params:{recipe_id: @recipe.id}
        expect(response).to redirect_to login_path
      end
    end
  end
  
  describe "Delete #destroy" do
    before do
      include SessionsHelper
      @user = create(:user)
      @recipe = create(:recipe)
      @bookmark = create(:bookmark, user_id: @user.id, recipe_id: @recipe.id)
    end
    context "ログイン済み" do
      before do
        session[:user_id] = @user.id
      end
      it '302レスポンスが返る' do
        delete :destroy, params:{id: @bookmark.id, recipe_id: @recipe.id}
        expect(response.status).to eq 302
      end
      it 'データベースからユーザーのブックマークが削除される' do
        expect{
          delete :destroy, params:{id: @bookmark.id, recipe_id: @recipe.id}
        }.to change(@user.bookmarks, :count).by(-1)
      end
      it 'データベースから記事のブックマークが削除される' do
        expect{
          delete :destroy, params:{id: @bookmark.id, recipe_id: @recipe.id}
        }.to change(@recipe.bookmarks, :count).by(-1)
      end
      it "記事詳細にリダイレクトする" do
        delete :destroy, params:{id: @bookmark.id, recipe_id: @recipe.id}
        expect(response).to redirect_to recipe_path(@recipe)
      end
    end
    context "ログインなし" do
      before do
        create(:bookmark, user_id: @user.id, recipe_id: @recipe.id)
      end
      it "302レスポンスが返る" do
        delete :destroy, params:{id: @bookmark.id, recipe_id: @recipe.id}
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        delete :destroy, params:{id: @bookmark.id, recipe_id: @recipe.id}
        expect(response).to redirect_to login_path
      end
    end
  end
end