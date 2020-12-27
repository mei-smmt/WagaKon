require 'rails_helper'

RSpec.describe BookmarksController, type: :controller do
  describe "Post #create" do
    before do
      include SessionsHelper
      @user = create(:user)
      @friend = create(:user)
      @recipe = create(:recipe, status: "published", user_id: @friend.id)
      create(:relationship, user_id: @user.id, friend_id: @friend.id, status: 'approved')
    end
    context "ログイン済み" do
      before do
        session[:user_id] = @user.id
      end
      context "同じ条件のブックマークが存在しない" do
        it 'データベースにユーザーの新しいブックマークが登録される' do
          expect{
            post :create, params:{recipe_id: @recipe.id}, xhr: true
          }.to change(@user.bookmarks, :count).by(1)
        end
        it 'データベースにレシピの新しいブックマークが登録される' do
          expect{
            post :create, params:{recipe_id: @recipe.id}, xhr: true
          }.to change(@recipe.bookmarks, :count).by(1)
        end
      end
      context "既に同じ条件のブックマークが存在する" do
        before do 
          create(:bookmark, user_id: @user.id, recipe_id: @recipe.id)
        end
        it 'データベースにユーザーの新しいブックマークが登録されない' do
          expect{
            post :create, params:{recipe_id: @recipe.id}, xhr: true
          }.not_to change(@user.bookmarks, :count)
        end
        it 'データベースにレシピの新しいブックマークが登録されない' do
          expect{
            post :create, params:{recipe_id: @recipe.id}, xhr: true
          }.not_to change(@recipe.bookmarks, :count)
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
      @friend = create(:user)
      @recipe = create(:recipe, status: "published", user_id: @friend.id)
      create(:relationship, user_id: @user.id, friend_id: @friend.id, status: 'approved')
      @bookmark = create(:bookmark, user_id: @user.id, recipe_id: @recipe.id)
    end
    context "ログイン済み" do
      before do
        session[:user_id] = @user.id
      end
      it 'データベースからユーザーのブックマークが削除される' do
        expect{
          delete :destroy, params:{id: @bookmark.id, recipe_id: @recipe.id}, xhr: true
        }.to change(@user.bookmarks, :count).by(-1)
      end
      it 'データベースからレシピのブックマークが削除される' do
        expect{
          delete :destroy, params:{id: @bookmark.id, recipe_id: @recipe.id}, xhr: true
        }.to change(@recipe.bookmarks, :count).by(-1)
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