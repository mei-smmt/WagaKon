require 'rails_helper'

RSpec.describe MaterialsController, type: :controller do
  describe "#new" do
    context '記事作者とログインユーザーが一致' do
      before do
        @user = create(:user)
        session[:user_id] = @user.id
        @recipe = create(:recipe, user_id: @user.id)
        get :new, params: {recipe_id: @recipe.id}
      end
      it "200レスポンスが返る" do
        expect(response.status).to eq(200)
      end
      it "@materialsに材料を割り当てる" do
        expect(assigns(:materials)).to all(be_a_new(Material))
      end
      it "@materialsのrecipe_idには@recipeのidが登録される" do
        expect(assigns(:materials)).to all(have_attributes(:recipe_id => @recipe.id))
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
      @materials = attributes_for_list(:material, 2)
    end
    context '記事作者とログインユーザーが一致' do
      before do
        @user = create(:user)
        @recipe = create(:recipe, user_id: @user.id)
        session[:user_id] = @user.id
      end
      context '有効なパラメータの場合' do
        before do
          @materials += attributes_for_list(:material, 8, name: nil, quantity: nil)
        end
        it '302レスポンスが返る' do
          post :create, params:{materials: @materials, recipe_id: @recipe.id}
          expect(response.status).to eq 302
        end
        it "@materialsのrecipe_idに@recipeのidを割り当てる" do
          post :create, params:{materials: @materials, recipe_id: @recipe.id}
          expect(assigns(:materials)).to all(have_attributes(:recipe_id => @recipe.id))
        end
        it '有効なパラメータを持つmaterialのみ、データベースに登録される' do
          expect{
            post :create, params:{materials: @materials, recipe_id: @recipe.id}
          }.to change(@recipe.materials, :count).by(2)
        end
        it 'ステップ入力画面にリダイレクトする' do
          post :create, params:{materials: @materials, recipe_id: @recipe.id}
          expect(response).to redirect_to new_recipe_step_path(@recipe)
        end
      end
      context '１つでも無効なパラメータを含む場合' do
        before do
          @materials << attributes_for(:material, name: nil)
        end
        it '200レスポンスが返る' do
          post :create, params:{materials: @materials, recipe_id: @recipe.id}
          expect(response.status).to eq 200
        end
        it 'データベースに新しい記事が登録されない' do
          expect{
            post :create, params:{materials: @materials, recipe_id: @recipe.id}
          }.not_to change(@recipe.materials, :count)
        end
        it ':newテンプレートを再表示する' do
          post :create, params:{materials: @materials, recipe_id: @recipe.id}
          expect(response).to render_template :new
        end
      end
    end
    context "記事作者とログインユーザーが一致しない" do
      before do
        @user, @login_user = create_list(:user, 2)
        @recipe = create(:recipe, user_id: @user.id)
        session[:user_id] = @login_user.id
        post :create, params:{materials: @materials, recipe_id: @recipe.id}
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
        @recipe = create(:recipe, user_id: @user.id)
        @materials = create_list(:material, 2, recipe_id: @recipe.id)
        get :edit, params: {recipe_id: @recipe.id}
      end
      it "200レスポンスが返る" do
        expect(response.status).to eq(200)
      end
      it "@materialsにリクエストされた記事のmaterialsを割り当てる" do
        expect(assigns(:materials)).to include(@materials[1])
      end
      it "@materialsのrecipe_idには@recipeのidが登録される" do
        expect(assigns(:materials)).to all(have_attributes(:recipe_id => @recipe.id))
      end
      it "@materialsの要素数は10" do
        expect(assigns(:materials).size).to eq 10
      end
      it ':editテンプレートを表示する' do
        expect(response).to render_template :edit
      end
    end
    context '記事作者とログインユーザーが一致していない' do
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
      @new_materials = attributes_for_list(:material, 3)
    end
    context '記事作者とログインユーザーが一致' do
      before do
        @user = create(:user)
        @recipe = create(:recipe, user_id: @user.id)
        @original_materials = create_list(:material, 2, recipe_id: @recipe.id)
        session[:user_id] = @user.id
      end
      context '有効なパラメータの場合' do
        before do
          @materials = @new_materials + attributes_for_list(:material, 7, name: nil, quantity: nil)
        end
        it '302レスポンスが返る' do
          patch :update, params:{materials: @materials, recipe_id: @recipe.id}
          expect(response.status).to eq 302
        end
        it "@materialsのrecipe_idに@recipeのidを割り当てる" do
          patch :update, params:{materials: @materials, recipe_id: @recipe.id}
          expect(assigns(:materials)).to all(have_attributes(:recipe_id => @recipe.id))
        end
        it '有効なパラメータを持つmaterialのみ、データベースに登録される' do
          expect{
            patch :update, params:{materials: @materials, recipe_id: @recipe.id}
          }.to change(@recipe.materials, :count).by(@new_materials.size - @original_materials.size)
        end
        it 'ステップ編集画面にリダイレクトする' do
          patch :update, params:{materials: @materials, recipe_id: @recipe.id}
          expect(response).to redirect_to edit_recipe_steps_path(@recipe)
        end
      end
      context '１つでも無効なパラメータを含む場合' do
        before do
          @new_materials << attributes_for(:material, name: nil)
        end
        it '200レスポンスが返る' do
          patch :update, params:{materials: @new_materials, recipe_id: @recipe.id}
          expect(response.status).to eq 200
        end
        it 'データベースは変更されない' do
          pending "実現できていない"
          expect{
            patch :update, params:{materials: @new_materials, recipe_id: @recipe.id}
          }.not_to change(@recipe.materials, :count)
        end
        it ':newテンプレートを再表示する' do
          patch :update, params:{materials: @new_materials, recipe_id: @recipe.id}
          expect(response).to render_template :edit
        end
      end
    end
    context "記事作者とログインユーザーが一致しない" do
      before do
        @user, @login_user = create_list(:user, 2)
        @recipe = create(:recipe, user_id: @user.id)
        session[:user_id] = @login_user.id
        patch :update, params:{materials: @new_materials, recipe_id: @recipe.id}
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
