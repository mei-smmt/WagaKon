require 'rails_helper'

RSpec.describe ToppagesController, type: :controller do
  describe '#index' do
    before do
      @user = create(:user)
      @friend = create(:user)
      @recipe1 = create(:recipe, status: 'published')
      @recipe2 = create(:recipe, status: 'published', user_id: @friend.id)
      @recipe3 = create(:recipe, status: 'draft')
      create(:relationship, user_id: @user.id, friend_id: @friend.id, status: 'approved')

      session[:user_id] = @user.id
      get :index
    end
    it '200レスポンスが返る' do
      expect(response.status).to eq(200)
    end
    it '@recipesに公開済みのレシピを割り当てる' do
      expect(assigns(:recipes)).to eq([@recipe2])
    end
    it ':indexテンプレートを表示する' do
      expect(response).to render_template :index
    end
  end
end
