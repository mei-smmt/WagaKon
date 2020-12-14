require 'rails_helper'

RSpec.describe StepsController, type: :controller do
  describe "#new" do
    context 'レシピ作者とログインユーザーが一致' do
      before do
        @user = create(:user)
        session[:user_id] = @user.id
        @recipe = create(:recipe, user_id: @user.id)
        get :new, params: {recipe_id: @recipe.id}
      end
      it "200レスポンスが返る" do
        expect(response.status).to eq(200)
      end
      it "@stepsにステップを割り当てる" do
        expect(assigns(:steps)).to all(be_a_new(Step))
      end
      it "@stepsのrecipe_idには@recipeのidが登録される" do
        expect(assigns(:steps)).to all(have_attributes(:recipe_id => @recipe.id))
      end
      it "@stepsの要素数は10" do
        expect(assigns(:steps).size).to eq 10
      end
      it ':newテンプレートを表示する' do
        expect(response).to render_template :new
      end
    end
    context "レシピ作者とログインユーザーが一致しない" do
      before do
        @user, @login_user = create_list(:user, 2)
        @recipe = create(:recipe, user_id: @user.id)
        session[:user_id] = @login_user.id
        get :new, params: {recipe_id: @recipe.id}
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
    context 'レシピ作者とログインユーザーが一致' do
      before do
        @user = create(:user)
        @recipe = create(:recipe, user_id: @user.id)
        session[:user_id] = @user.id
      end
      context '有効なパラメータの場合' do
        before do
          @steps += attributes_for_list(:step, 8, number: nil, content: nil)
        end
        it '302レスポンスが返る' do
          post :create, params:{steps: @steps, recipe_id: @recipe.id}
          expect(response.status).to eq 302
        end
        it "@stepsのrecipe_idに@recipeのidを割り当てる" do
          post :create, params:{steps: @steps, recipe_id: @recipe.id}
          expect(assigns(:steps)).to all(have_attributes(:recipe_id => @recipe.id))
        end
        it '有効なパラメータを持つstepのみ、データベースに登録される' do
          expect{
            post :create, params:{steps: @steps, recipe_id: @recipe.id}
          }.to change(@recipe.steps, :count).by(2)
        end
        it 'ステップ入力画面にリダイレクトする' do
          post :create, params:{steps: @steps, recipe_id: @recipe.id}
          expect(response).to redirect_to preview_recipe_url(@recipe)
        end
      end
      context '無効なパラメータを含む場合(contentが１４０文字より長い)' do
        before do
          text = "a" * 150
          @steps << attributes_for(:step, content: text)
        end
        it '200レスポンスが返る' do
          post :create, params:{steps: @steps, recipe_id: @recipe.id}
          expect(response.status).to eq 200
        end
        it 'データベースに新しいレシピが登録されない' do
          expect{
            post :create, params:{steps: @steps, recipe_id: @recipe.id}
          }.not_to change(@recipe.steps, :count)
        end
        it ':newテンプレートを再表示する' do
          post :create, params:{steps: @steps, recipe_id: @recipe.id}
          expect(response).to render_template :new
        end
      end
    end
    context "レシピ作者とログインユーザーが一致しない" do
      before do
        @user, @login_user = create_list(:user, 2)
        @recipe = create(:recipe, user_id: @user.id)
        session[:user_id] = @login_user.id
        post :create, params:{steps: @steps, recipe_id: @recipe.id}
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
    context 'レシピ作者とログインユーザーが一致' do
      before do
        @user = create(:user)
        session[:user_id] = @user.id
        @recipe = create(:recipe, user_id: @user.id)
        @steps = create_list(:step, 2, recipe_id: @recipe.id)
        get :edit, params: {recipe_id: @recipe.id}
      end
      it "200レスポンスが返る" do
        expect(response.status).to eq(200)
      end
      it "@stepsにリクエストされたレシピのstepsを割り当てる" do
        expect(assigns(:steps)).to include(@steps[1])
      end
      it "@stepsのrecipe_idには@recipeのidが登録される" do
        expect(assigns(:steps)).to all(have_attributes(:recipe_id => @recipe.id))
      end
      it "@stepsの要素数は10" do
        expect(assigns(:steps).size).to eq 10
      end
      it ':editテンプレートを表示する' do
        expect(response).to render_template :edit
      end
    end
    context 'レシピ作者とログインユーザーが一致していない' do
      before do
        @user, @login_user = create_list(:user, 2)
        @recipe = create(:recipe, user_id: @user.id)
        session[:user_id] = @login_user.id
        get :edit, params: {recipe_id: @recipe.id}
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
    context 'レシピ作者とログインユーザーが一致' do
      before do
        @user = create(:user)
        @recipe = create(:recipe, user_id: @user.id)
        @original_steps = create_list(:step, 2, recipe_id: @recipe.id)
        session[:user_id] = @user.id
      end
      context '有効なパラメータの場合' do
        before do
          @steps = @new_steps + attributes_for_list(:step, 7, number: nil, content: nil)
        end
        it '302レスポンスが返る' do
          patch :update, params:{steps: @steps, recipe_id: @recipe.id}
          expect(response.status).to eq 302
        end
        it "@stepsのrecipe_idに@recipeのidを割り当てる" do
          patch :update, params:{steps: @steps, recipe_id: @recipe.id}
          expect(assigns(:steps)).to all(have_attributes(:recipe_id => @recipe.id))
        end
        it '有効なパラメータを持つstepのみ、データベースに登録される' do
          expect{
            patch :update, params:{steps: @steps, recipe_id: @recipe.id}
          }.to change(@recipe.steps, :count).by(@new_steps.size - @original_steps.size)
        end
        it 'ステップ編集画面にリダイレクトする' do
          patch :update, params:{steps: @steps, recipe_id: @recipe.id}
          expect(response).to redirect_to recipe_url(@recipe)
        end
      end
      context '無効なパラメータを含む場合(contentが１４０文字より長い)' do
        before do
          text = "a" * 150
          @new_steps << attributes_for(:step, content: text)
        end
        it '200レスポンスが返る' do
          patch :update, params:{steps: @new_steps, recipe_id: @recipe.id}
          expect(response.status).to eq 200
        end
        it 'データベースは変更されない' do
          expect{
            patch :update, params:{steps: @new_steps, recipe_id: @recipe.id}
          }.not_to change(@recipe.steps, :count)
        end
        it ':newテンプレートを再表示する' do
          patch :update, params:{steps: @new_steps, recipe_id: @recipe.id}
          expect(response).to render_template :edit
        end
      end
    end
    context "レシピ作者とログインユーザーが一致しない" do
      before do
        @user, @login_user = create_list(:user, 2)
        @recipe = create(:recipe, user_id: @user.id)
        session[:user_id] = @login_user.id
        patch :update, params:{steps: @new_steps, recipe_id: @recipe.id}
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
