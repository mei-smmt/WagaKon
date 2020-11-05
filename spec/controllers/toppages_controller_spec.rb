require 'rails_helper'

RSpec.describe ToppagesController, type: :controller do
  describe "#index" do
    before do
      @recipe1, @recipe2 = create_list(:recipe, 2, status: "published")
      @recipe3 = create(:recipe, status: "draft")
      get :index
    end
    it "200レスポンスが返る" do
      expect(response.status).to eq(200)
    end
    it "@recipesに公開済みの記事を割り当てる" do
      expect(assigns(:recipes)).to eq([@recipe1, @recipe2])
    end
    it ':indexテンプレートを表示する' do
      expect(response).to render_template :index
    end
  end
end