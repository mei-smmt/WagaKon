require 'rails_helper'

RSpec.describe MaterialsController, type: :controller do
  describe "#new" do
    context '記事作者とログインユーザーが一致' do
      before do
        @user = create(:user)
        session[:user_id] = @user.id
        @article = create(:article, user_id: @user.id)
        get :new, params: {article_id: @article.id}
      end
      it "200レスポンスが返る" do
        expect(response.status).to eq(200)
      end
      it "@materialsに材料を割り当てる" do
        expect(assigns(:materials)).to all(be_a_new(Material))
      end
      it "@materialsのarticle_idには@articleのidが登録される" do
        expect(assigns(:materials)).to all(have_attributes(:article_id => @article.id))
      end
      it "@materialsの要素数は10" do
        expect(assigns(:materials).size).to eq 10
      end
      it ':newテンプレートを表示する' do
        expect(response).to render_template :new
      end
    end
    context "記事作者とログインユーザーが一致しない" do
      before do
        @user, @login_user = create_list(:user, 2)
        @article = create(:article, user_id: @user.id)
        session[:user_id] = @login_user.id
        get :new, params: {article_id: @article.id}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it 'rootにリダイレクトする' do
        expect(response).to redirect_to root_path
      end
    end
  end
end  
