require 'rails_helper'

RSpec.describe IngredientsController, type: :controller do
  before do
    @recipe_user = create(:user)
    @recipe = create(:recipe, user_id: @recipe_user.id)
    @orig_ingredients = create_list(:ingredient, 2, recipe_id: @recipe.id)
  end
  describe '#edit' do
    context 'レシピ作者とログインユーザーが一致する場合' do
      before do
        @login_user = @recipe_user
        session[:user_id] = @login_user.id
        get :edit, params: { recipe_id: @recipe.id }
      end
      it '200レスポンスが返る' do
        expect(response.status).to eq(200)
      end
      it '@ingredientsにリクエストされたレシピのingredientsを割り当てる' do
        expect(assigns(:ingredients)).to include(@orig_ingredients[1])
      end
      it '@ingredientsのrecipe_idには@recipeのidが登録される' do
        expect(assigns(:ingredients)).to all(have_attributes(recipe_id: @recipe.id))
      end
      it '@ingredientsの要素数は10' do
        expect(assigns(:ingredients).size).to eq 10
      end
      it ':editテンプレートを表示する' do
        expect(response).to render_template :edit
      end
    end
    context 'レシピ作者とログインユーザーが一致しない場合' do
      before do
        @login_user = create(:user)
        session[:user_id] = @login_user.id
        get :edit, params: { recipe_id: @recipe.id }
      end
      it '302レスポンスが返る' do
        expect(response.status).to eq(302)
      end
      it 'rootにリダイレクトする' do
        expect(response).to redirect_to root_url
      end
    end
  end
  describe 'Patch #update' do
    before do
      @new_ingredients = attributes_for_list(:ingredient, 3)
    end
    context 'レシピ作者とログインユーザーが一致する場合' do
      before do
        @login_user = @recipe_user
        session[:user_id] = @login_user.id
      end
      context '有効なパラメータの場合' do
        before do
          @ingredients = @new_ingredients + attributes_for_list(:ingredient, 7, name: nil, quantity: nil)
        end
        it '302レスポンスが返る' do
          patch :update, params: { ingredients: @ingredients, recipe_id: @recipe.id }
          expect(response.status).to eq 302
        end
        it '@ingredientsのrecipe_idに@recipeのidを割り当てる' do
          patch :update, params: { ingredients: @ingredients, recipe_id: @recipe.id }
          expect(assigns(:ingredients)).to all(have_attributes(recipe_id: @recipe.id))
        end
        it '有効なパラメータを持つingredientのみ、データベースに登録される' do
          expect  do
            patch :update, params: { ingredients: @ingredients, recipe_id: @recipe.id }
          end.to change(@recipe.ingredients, :count).by(@new_ingredients.size - @orig_ingredients.size)
        end
        it '手順編集画面にリダイレクトする' do
          patch :update, params: { ingredients: @ingredients, recipe_id: @recipe.id }
          expect(response).to redirect_to edit_recipe_steps_url(@recipe)
        end
      end
      context '１つでも無効なパラメータを含む場合' do
        before do
          @new_ingredients << attributes_for(:ingredient, name: nil)
        end
        it '200レスポンスが返る' do
          patch :update, params: { ingredients: @new_ingredients, recipe_id: @recipe.id }
          expect(response.status).to eq 200
        end
        it 'データベースは変更されない' do
          expect  do
            patch :update, params: { ingredients: @new_ingredients, recipe_id: @recipe.id }
          end.not_to change(@recipe.ingredients, :count)
        end
        it ':editテンプレートを再表示する' do
          patch :update, params: { ingredients: @new_ingredients, recipe_id: @recipe.id }
          expect(response).to render_template :edit
        end
      end
    end
    context 'レシピ作者とログインユーザーが一致しない場合' do
      before do
        @login_user = create(:user)
        session[:user_id] = @login_user.id
        patch :update, params: { ingredients: @new_ingredients, recipe_id: @recipe.id }
      end
      it '302レスポンスが返る' do
        expect(response.status).to eq(302)
      end
      it 'rootにリダイレクトする' do
        expect(response).to redirect_to root_url
      end
    end
  end
end
