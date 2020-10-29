require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "#show" do
    before do
      @user = create(:user)
      get :show, params: {id: @user.id}
    end
    it "200レスポンスが返る" do
      expect(response.status).to eq(200)
    end
    it "@userにリクエストされたユーザーを割り当てる" do
      expect(assigns(:user)).to eq(@user)
    end
    it ':showテンプレートを表示する' do
      expect(response).to render_template :show
    end
  end
end