require 'rails_helper'

RSpec.describe ToppagesController, type: :controller do
  describe "#index" do
    before do
      @article1, @article2 = create_list(:article, 2, status: "published")
      @article3 = create(:article, status: "draft")
      get :index
    end
    it "200レスポンスが返る" do
      expect(response.status).to eq(200)
    end
    it "@articlesに公開済みの記事を割り当てる" do
      expect(assigns(:articles)).to eq([@article1, @article2])
    end
  end
end