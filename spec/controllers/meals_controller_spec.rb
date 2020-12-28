require 'rails_helper'

RSpec.describe MealsController, type: :controller do
  describe "#index" do
    before do
      @user = create(:user)
      @meals = []
      (0..6).each do |index|
        @meals << create(:meal, user_id: @user.id, day_of_week: index)
      end
      session[:user_id] = @user.id
      get :index
    end
    it "200レスポンスが返る" do
      expect(response.status).to eq(200)
    end
    it "@recipesに@userの献立を割り当てる" do
      expect(assigns(:meals)).to eq(@meals)
    end
    it ':indexテンプレートを表示する' do
      expect(response).to render_template :index
    end
  end
end