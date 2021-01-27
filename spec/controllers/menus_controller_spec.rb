require 'rails_helper'

RSpec.describe MenusController, type: :controller do
  before do
    @user = create(:user)
    @friend = create(:user)
    @recipe = create(:recipe, status: 'published', user_id: @friend.id)
    @meal = create(:meal, user_id: @user.id)
    create(:relationship, user_id: @user.id, friend_id: @friend.id, status: 'approved')
  end
  describe 'Post #create' do
    context 'ログイン済みの場合' do
      before do
        session[:user_id] = @user.id
      end
      context '同じ条件のメニューが存在しない場合' do
        it 'データベースに献立の新しいメニューが登録される' do
          expect do
            post :create, params: { day: 'sun', recipe_id: @recipe.id }
          end.to change(@meal.menus, :count).by(1)
        end
        it 'データベースにレシピの新しいメニューが登録される' do
          expect do
            post :create, params: { day: 'sun', recipe_id: @recipe.id }
          end.to change(@recipe.menus, :count).by(1)
        end
      end
      context '既に同じ条件のメニューが存在する場合' do
        before do
          create(:menu, meal_id: @meal.id, recipe_id: @recipe.id)
        end
        it 'データベースに献立の新しいメニューが登録されない' do
          expect do
            post :create, params: { day: 'sun', recipe_id: @recipe.id }
          end.not_to change(@meal.menus, :count)
        end
        it 'データベースにレシピの新しいメニューが登録されない' do
          expect do
            post :create, params: { day: 'sun', recipe_id: @recipe.id }
          end.not_to change(@recipe.menus, :count)
        end
      end
    end
    context 'ログインなしの場合' do
      it '302レスポンスが返る' do
        post :create, params: { day: 'sun', recipe_id: @recipe.id }
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        post :create, params: { day: 'sun', recipe_id: @recipe.id }
        expect(response).to redirect_to login_url
      end
    end
  end
  describe 'Delete #destroy' do
    before do
      @menu = create(:menu, meal_id: @meal.id, recipe_id: @recipe.id)
    end
    context 'ログイン済みの場合' do
      before do
        session[:user_id] = @user.id
      end
      it 'データベースから献立のメニューが削除される' do
        expect do
          delete :destroy, params: { id: @meal.id, recipe_id: @recipe.id, day: 'sun' }
        end.to change(@meal.menus, :count).by(-1)
      end
      it 'データベースからレシピのメニューが削除される' do
        expect do
          delete :destroy, params: { id: @meal.id, recipe_id: @recipe.id, day: 'sun' }
        end.to change(@recipe.menus, :count).by(-1)
      end
    end
    context 'ログインなしの場合' do
      before do
        create(:menu, meal_id: @meal.id, recipe_id: @recipe.id)
      end
      it '302レスポンスが返る' do
        delete :destroy, params: { id: @menu.id, recipe_id: @recipe.id }
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        delete :destroy, params: { id: @menu.id, recipe_id: @recipe.id }
        expect(response).to redirect_to login_url
      end
    end
  end
end
