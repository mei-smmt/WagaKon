require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe "#show" do
    context 'リクエストした記事のstatusが「公開」の場合' do
      before do
        @article = create(:article, status: "published")
        get :show, params: {id: @article.id}
      end
      it "200レスポンスが返る" do
        expect(response.status).to eq(200)
      end
      it "@articleにリクエストされた記事を割り当てる" do
        expect(assigns(:article)).to eq(@article)
      end
      it ':showテンプレートを表示する' do
        expect(response).to render_template :show
      end
    end
    context 'リクエストした記事のstatusが「非公開」の場合' do
      before do
        @article = create(:article, status: "draft")
        session[:user_id] = @article.user_id
        get :show, params: {id: @article.id}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it "@articleにリクエストされた記事を割り当てる" do
        expect(assigns(:article)).to eq(@article)
      end
      it ':previewにリダイレクトする' do
        expect(response).to redirect_to preview_article_path(@article)
      end
    end
  end
  
  describe "#new" do
    context "ログイン済み" do
      before do
        @user = create(:user)
        session[:user_id] = @user.id
        get :new
      end
      it "200レスポンスが返る" do
        expect(response.status).to eq(200)
      end
      it "@articleに新しい記事を割り当てる" do
        expect(assigns(:article)).to be_a_new(Article)
      end
      it ':newテンプレートを表示する' do
        expect(response).to render_template :new
      end
    end
    context "ログインなし" do
      before do
        session[:user_id] = nil
        get :new
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it '#loginにリダイレクトする' do
        expect(response).to redirect_to login_path
      end
    end
  end
  
  describe 'Post #create' do
    before do
      @user = create(:user)
      session[:user_id] = @user.id
    end
    context '有効なパラメータの場合' do
      before do
        @article = attributes_for(:article)
      end
      it '302レスポンスが返る' do
        post :create, params:{article: @article}
        expect(response.status).to eq 302
      end
      it 'データベースにユーザーの新しい記事が登録される' do
        expect{
          post :create, params:{article: @article}
        }.to change(@user.articles, :count).by(1)
      end
      it '材料入力画面にリダイレクトする' do
        post :create, params:{article: @article}
        expect(response).to redirect_to new_article_material_path(@user.articles.last)
      end
    end
    context '無効なパラメータの場合' do
      before do
        @invalid_article = attributes_for(:article, title: nil)
      end
      it '200レスポンスが返る' do
        post :create, params:{article: @invalid_article}
        expect(response.status).to eq 200
      end
      it 'データベースに新しい記事が登録されない' do
        expect{
          post :create, params:{article: @invalid_article}
        }.not_to change(@user.articles, :count)
      end
      it ':newテンプレートを再表示する' do
        post :create, params:{article: @invalid_article}
        expect(response).to render_template :new
      end
    end
  end
  
  describe "#edit" do
    context '記事作者とログインユーザーが一致' do
      before do
        @user = create(:user)
        @article = create(:article, user_id: @user.id)
        session[:user_id] = @user.id
        get :edit, params: {id: @article.id}
      end
      it "200レスポンスが返る" do
        expect(response.status).to eq(200)
      end
      it "@articleにリクエストされた記事を割り当てる" do
        expect(assigns(:article)).to eq(@article)
      end
      it ':editテンプレートを表示する' do
        expect(response).to render_template :edit
      end
    end
    context '記事作者とログインユーザーが一致していない' do
      before do
        @user, @login_user = create_list(:user, 2)
        @article = create(:article, user_id: @user.id)
        session[:user_id] = @login_user.id
        get :edit, params: {id: @article.id}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it 'rootにリダイレクトする' do
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe 'Patch #update' do
    context '記事作者とログインユーザーが一致' do
      before do
        @user = create(:user)
        @article = create(:article, user_id: @user.id)
        @original_title = @article.title
        session[:user_id] = @user.id
      end
      context '有効なパラメータの場合' do
        before do
          patch :update, params:{id: @article.id, article: attributes_for(:article, title: "new_title")}
        end
        it '302レスポンスが返る' do
          expect(response.status).to eq 302
        end
        it 'データベースの記事が更新される' do
          @article.reload
          expect(@article.title).to eq 'new_title'
        end
        it '材料編集画面にリダイレクトする' do
          expect(response).to redirect_to edit_article_materials_path(@article)
        end
      end
      context '無効なパラメータの場合' do
        before do
          patch :update, params:{id: @article.id, article: attributes_for(:article, title: nil)}
        end
        it '200レスポンスが返る' do
          expect(response.status).to eq 200
        end
        it 'データベースのユーザーは更新されない' do
          @article.reload
          expect(@article.title).to eq @original_title
        end
        it ':editテンプレートを再表示する' do
          expect(response).to render_template :edit
        end
      end
    end
    context '記事作者とログインユーザーが一致しない' do
      before do
        @user, @login_user = create_list(:user, 2)
        @article = create(:article, user_id: @user.id)
        session[:user_id] = @login_user.id
        patch :update, params:{id: @article.id, article: attributes_for(:article, title: "new_title")}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it 'rootにリダイレクトする' do
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe "Delete #destroy" do
    context '記事作者とログインユーザーが一致' do
      before do
        @user = create(:user)
        @article = create(:article, user_id: @user.id)
        session[:user_id] = @user.id
      end
      it '302レスポンスが返る' do
        delete :destroy, params: {id: @article.id}
        expect(response.status).to eq 302
      end
      it 'データベースからユーザーの記事が削除される' do
        expect{
          delete :destroy, params: {id: @article.id}
        }.to change(@user.articles, :count).by(-1)
      end
      it 'rootにリダイレクトする' do
        delete :destroy, params: {id: @article.id}
        expect(response).to redirect_to root_path
      end
    end
    context '記事作者とログインユーザーが一致しない' do
      before do
        @user, @login_user = create_list(:user, 2)
        @article = create(:article, user_id: @user.id)
        session[:user_id] = @login_user.id
      end
      it "302レスポンスが返る" do
        delete :destroy, params: {id: @article.id}
        expect(response.status).to eq(302)
      end
      it 'データベースからユーザーの記事は削除されない' do
        expect{
          delete :destroy, params: {id: @article.id}
        }.not_to change(@user.articles, :count)
      end
      it 'rootにリダイレクトする' do
        delete :destroy, params: {id: @article.id}
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe "#preview" do
    context '記事作者とログインユーザーが一致' do
      before do
        @user = create(:user)
        @article = create(:article, user_id: @user.id)
        session[:user_id] = @user.id
        get :preview, params: {id: @article.id}
      end
      it "200レスポンスが返る" do
        expect(response.status).to eq(200)
      end
      it "@articleにリクエストされた記事を割り当てる" do
        expect(assigns(:article)).to eq(@article)
      end
      it ':previewテンプレートを表示する' do
        expect(response).to render_template :preview
      end
    end
    context '記事作者とログインユーザーが一致していない' do
      before do
        @user, @login_user = create_list(:user, 2)
        @article = create(:article, user_id: @user.id)
        session[:user_id] = @login_user.id
        get :preview, params: {id: @article.id}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it 'rootにリダイレクトする' do
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe 'Patch #publish' do
    context '記事作者とログインユーザーが一致' do
      before do
        @user = create(:user)
        @article = create(:article, user_id: @user.id, status: "draft")
        session[:user_id] = @user.id
        patch :publish, params:{id: @article.id, article: attributes_for(:article, status: "published")}
      end
      it '302レスポンスが返る' do
        expect(response.status).to eq 302
      end
      it 'データベースの記事が更新される' do
        @article.reload
        expect(@article.status).to eq 'published'
      end
      it '記事詳細画面にリダイレクトする' do
        expect(response).to redirect_to article_url(@article)
      end
    end
    context '記事作者とログインユーザーが一致しない' do
      before do
        @user, @login_user = create_list(:user, 2)
        @article = create(:article, user_id: @user.id)
        session[:user_id] = @login_user.id
        patch :publish, params:{id: @article.id, article: attributes_for(:article, status: "published")}
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