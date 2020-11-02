require 'rails_helper'

RSpec.describe BookmarksController, type: :controller do
  describe "Post #create" do
    before do
      include SessionsHelper
      @user = create(:user)
      @article = create(:article)
    end
    context "ログイン済み" do
      before do
        session[:user_id] = @user.id
      end
      context "同じ条件のブックマークが存在しない" do
        it '302レスポンスが返る' do
          post :create, params:{article_id: @article.id}
          expect(response.status).to eq 302
        end
        it 'データベースにユーザーの新しいブックマークが登録される' do
          expect{
            post :create, params:{article_id: @article.id}
          }.to change(@user.bookmarks, :count).by(1)
        end
        it 'データベースに記事の新しいブックマークが登録される' do
          expect{
            post :create, params:{article_id: @article.id}
          }.to change(@article.bookmarks, :count).by(1)
        end
        it "記事詳細にリダイレクトする" do
          post :create, params:{article_id: @article.id}
          expect(response).to redirect_to article_path(@article)
        end
      end
      context "既に同じ条件のブックマークが存在する" do
        before do 
          create(:bookmark, user_id: @user.id, article_id: @article.id)
        end
        it '302レスポンスが返る' do
          post :create, params:{article_id: @article.id}
          expect(response.status).to eq 302
        end
        it 'データベースにユーザーの新しいブックマークが登録されない' do
          expect{
            post :create, params:{article_id: @article.id}
          }.not_to change(@user.bookmarks, :count)
        end
        it 'データベースに記事の新しいブックマークが登録されない' do
          expect{
            post :create, params:{article_id: @article.id}
          }.not_to change(@article.bookmarks, :count)
        end
        it "記事詳細にリダイレクトする" do
          post :create, params:{article_id: @article.id}
          expect(response).to redirect_to article_path(@article)
        end
      end
    end
    context "ログインなし" do
      it "302レスポンスが返る" do
        post :create, params:{article_id: @article.id}
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        post :create, params:{article_id: @article.id}
        expect(response).to redirect_to login_path
      end
    end
  end
  
  describe "Delete #destroy" do
    before do
      include SessionsHelper
      @user = create(:user)
      @article = create(:article)
      @bookmark = create(:bookmark, user_id: @user.id, article_id: @article.id)
    end
    context "ログイン済み" do
      before do
        session[:user_id] = @user.id
      end
      it '302レスポンスが返る' do
        delete :destroy, params:{id: @bookmark.id, article_id: @article.id}
        expect(response.status).to eq 302
      end
      it 'データベースからユーザーのブックマークが削除される' do
        expect{
          delete :destroy, params:{id: @bookmark.id, article_id: @article.id}
        }.to change(@user.bookmarks, :count).by(-1)
      end
      it 'データベースから記事のブックマークが削除される' do
        expect{
          delete :destroy, params:{id: @bookmark.id, article_id: @article.id}
        }.to change(@article.bookmarks, :count).by(-1)
      end
      it "記事詳細にリダイレクトする" do
        delete :destroy, params:{id: @bookmark.id, article_id: @article.id}
        expect(response).to redirect_to article_path(@article)
      end
    end
    context "ログインなし" do
      before do
        create(:bookmark, user_id: @user.id, article_id: @article.id)
      end
      it "302レスポンスが返る" do
        delete :destroy, params:{id: @bookmark.id, article_id: @article.id}
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        delete :destroy, params:{id: @bookmark.id, article_id: @article.id}
        expect(response).to redirect_to login_path
      end
    end
  end
end