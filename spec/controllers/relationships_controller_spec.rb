require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  before do
    @user = create(:user)
    @friend = create(:user)
  end
  describe "Post #create" do
    context "ログイン済み" do
      before { session[:user_id] = @user.id }
      context "同じ条件のリレーションが存在しない" do
        it '302レスポンスが返る' do
          post :create, params:{user_id: @friend.id}
          expect(response.status).to eq 302
        end
        it 'データベースにユーザーの新しいリレーションが登録される' do
          expect{
            post :create, params:{user_id: @friend.id}
          }.to change(@user.relationships, :count).by(1)
        end
        it 'データベースにフレンドの新しいリレーションが登録される' do
          expect{
            post :create, params:{user_id: @friend.id}
          }.to change(@friend.relationships, :count).by(1)
        end
        it "友達ページにリダイレクトする" do
          post :create, params:{user_id: @friend.id}
          expect(response).to redirect_to friends_users_url
        end
      end
      context "既に同じ条件のリレーションが存在する" do
        before do 
          create(:relationship, user_id: @user.id, friend_id: @friend.id)
          create(:relationship, user_id: @friend.id, friend_id: @user.id)
        end
        it '302レスポンスが返る' do
          post :create, params:{user_id: @friend.id}
          expect(response.status).to eq 302
        end
        it 'データベースにユーザーの新しいリレーションが登録されない' do
          expect{
            post :create, params:{user_id: @friend.id}
          }.not_to change(@user.relationships, :count)
        end
        it 'データベースにフレンドの新しいリレーションが登録されない' do
          expect{
            post :create, params:{user_id: @friend.id}
          }.not_to change(@friend.relationships, :count)
        end
        it "友達ページにリダイレクトする" do
          post :create, params:{user_id: @friend.id}
          expect(response).to redirect_to friends_users_url
        end
      end
    end
    context "ログインなし" do
      it "302レスポンスが返る" do
        post :create, params:{user_id: @friend.id}
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        post :create, params:{user_id: @friend.id}
        expect(response).to redirect_to login_url
      end
    end
  end
  
  describe "Patch #update" do
    before do
      @user_relationship = create(:relationship, user_id: @user.id, friend_id: @friend.id, status: 'receiving')
      @friend_relationship = create(:relationship, user_id: @friend.id, friend_id: @user.id, status: 'requesting')
    end
    context "ログイン済み" do
      before do
        session[:user_id] = @user.id
        patch :update, params:{id: @user.id, user_id: @friend.id}
      end
      it '302レスポンスが返る' do
        expect(response.status).to eq 302
      end
      it 'リレーションstatusがapprovedになる' do
        expect([@user_relationship.reload.status, @friend_relationship.reload.status]).to eq ['approved', 'approved']
      end
      it "友達ページにリダイレクトする" do
        expect(response).to redirect_to friends_users_url
      end
    end
    context "ログインなし" do
      before do
        patch :update, params:{id: @user.id, user_id: @friend.id}
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
    before do
      @relationship = create(:relationship, user_id: @user.id, friend_id: @friend.id)
      create(:relationship, user_id: @friend.id, friend_id: @user.id)
    end
    context "ログイン済み" do
      before do
        session[:user_id] = @user.id
      end
      it '302レスポンスが返る' do
        delete :destroy, params:{id: @relationship.id, user_id: @friend.id}
        expect(response.status).to eq 302
      end
      it 'データベースからユーザーのリレーションが削除される' do
        expect{
          delete :destroy, params:{id: @relationship.id, user_id: @friend.id}
        }.to change(@user.relationships, :count).by(-1)
      end
      it 'データベースからフレンドのリレーションが削除される' do
        expect{
          delete :destroy, params:{id: @relationship.id, user_id: @friend.id}
        }.to change(@friend.relationships, :count).by(-1)
      end
      it "友達ページにリダイレクトする" do
        delete :destroy, params:{id: @relationship.id, user_id: @friend.id}
        expect(response).to redirect_to friends_users_url
      end
    end
    context "ログインなし" do
      it "302レスポンスが返る" do
        delete :destroy, params:{id: @relationship.id, user_id: @friend.id}
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        delete :destroy, params:{id: @relationship.id, user_id: @friend.id}
        expect(response).to redirect_to login_url
      end
    end
  end
end