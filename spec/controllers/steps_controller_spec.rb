require 'rails_helper'

RSpec.describe StepsController, type: :controller do
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
      it "@stepsにステップを割り当てる" do
        expect(assigns(:steps)).to all(be_a_new(Step))
      end
      it "@stepsのarticle_idには@articleのidが登録される" do
        expect(assigns(:steps)).to all(have_attributes(:article_id => @article.id))
      end
      it "@stepsの要素数は10" do
        expect(assigns(:steps).size).to eq 10
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
  
  describe 'Post #create' do
    before do
      @steps = attributes_for_list(:step, 2)
    end
    context '記事作者とログインユーザーが一致' do
      before do
        @user = create(:user)
        @article = create(:article, user_id: @user.id)
        session[:user_id] = @user.id
      end
      context '有効なパラメータの場合' do
        before do
          @steps += attributes_for_list(:step, 8, number: nil, content: nil)
        end
        it '302レスポンスが返る' do
          post :create, params:{steps: @steps, article_id: @article.id}
          expect(response.status).to eq 302
        end
        it "@stepsのarticle_idに@articleのidを割り当てる" do
          post :create, params:{steps: @steps, article_id: @article.id}
          expect(assigns(:steps)).to all(have_attributes(:article_id => @article.id))
        end
        it '有効なパラメータを持つstepのみ、データベースに登録される' do
          expect{
            post :create, params:{steps: @steps, article_id: @article.id}
          }.to change(@article.steps, :count).by(2)
        end
        it 'ステップ入力画面にリダイレクトする' do
          post :create, params:{steps: @steps, article_id: @article.id}
          expect(response).to redirect_to preview_article_url(@article)
        end
      end
      context '１つでも無効なパラメータを含む場合' do
        before do
          @steps << attributes_for(:step, number: nil)
        end
        it '200レスポンスが返る' do
          post :create, params:{steps: @steps, article_id: @article.id}
          expect(response.status).to eq 200
        end
        it 'データベースに新しい記事が登録されない' do
          expect{
            post :create, params:{steps: @steps, article_id: @article.id}
          }.not_to change(@article.steps, :count)
        end
        it ':newテンプレートを再表示する' do
          post :create, params:{steps: @steps, article_id: @article.id}
          expect(response).to render_template :new
        end
      end
    end
    context "記事作者とログインユーザーが一致しない" do
      before do
        @user, @login_user = create_list(:user, 2)
        @article = create(:article, user_id: @user.id)
        session[:user_id] = @login_user.id
        post :create, params:{steps: @steps, article_id: @article.id}
      end
      it "302レスポンスが返る" do
        expect(response.status).to eq(302)
      end
      it 'rootにリダイレクトする' do
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe "#edit" do
    context '記事作者とログインユーザーが一致' do
      before do
        @user = create(:user)
        session[:user_id] = @user.id
        @article = create(:article, user_id: @user.id)
        @steps = create_list(:step, 2, article_id: @article.id)
        get :edit, params: {article_id: @article.id}
      end
      it "200レスポンスが返る" do
        expect(response.status).to eq(200)
      end
      it "@stepsにリクエストされた記事のstepsを割り当てる" do
        expect(assigns(:steps)).to include(@steps[1])
      end
      it "@stepsのarticle_idには@articleのidが登録される" do
        expect(assigns(:steps)).to all(have_attributes(:article_id => @article.id))
      end
      it "@stepsの要素数は10" do
        expect(assigns(:steps).size).to eq 10
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
        get :edit, params: {article_id: @article.id}
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
    before do
      @new_steps = attributes_for_list(:step, 3)
    end
    context '記事作者とログインユーザーが一致' do
      before do
        @user = create(:user)
        @article = create(:article, user_id: @user.id)
        @original_steps = create_list(:step, 2, article_id: @article.id)
        session[:user_id] = @user.id
      end
      context '有効なパラメータの場合' do
        before do
          @steps = @new_steps + attributes_for_list(:step, 7, number: nil, content: nil)
        end
        it '302レスポンスが返る' do
          patch :update, params:{steps: @steps, article_id: @article.id}
          expect(response.status).to eq 302
        end
        it "@stepsのarticle_idに@articleのidを割り当てる" do
          patch :update, params:{steps: @steps, article_id: @article.id}
          expect(assigns(:steps)).to all(have_attributes(:article_id => @article.id))
        end
        it '有効なパラメータを持つstepのみ、データベースに登録される' do
          expect{
            patch :update, params:{steps: @steps, article_id: @article.id}
          }.to change(@article.steps, :count).by(@new_steps.size - @original_steps.size)
        end
        it 'ステップ編集画面にリダイレクトする' do
          patch :update, params:{steps: @steps, article_id: @article.id}
          expect(response).to redirect_to article_url(@article)
        end
      end
      context '１つでも無効なパラメータを含む場合' do
        before do
          @new_steps << attributes_for(:step, number: nil)
        end
        it '200レスポンスが返る' do
          patch :update, params:{steps: @new_steps, article_id: @article.id}
          expect(response.status).to eq 200
        end
        it 'データベースは変更されない' do
          pending "実現できていない"
          expect{
            patch :update, params:{steps: @new_steps, article_id: @article.id}
          }.not_to change(@article.steps, :count)
        end
        it ':newテンプレートを再表示する' do
          patch :update, params:{steps: @new_steps, article_id: @article.id}
          expect(response).to render_template :edit
        end
      end
    end
    context "記事作者とログインユーザーが一致しない" do
      before do
        @user, @login_user = create_list(:user, 2)
        @article = create(:article, user_id: @user.id)
        session[:user_id] = @login_user.id
        patch :update, params:{steps: @new_steps, article_id: @article.id}
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
