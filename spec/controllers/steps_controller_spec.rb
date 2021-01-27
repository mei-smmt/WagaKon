require 'rails_helper'

RSpec.describe StepsController, type: :controller do
  before do
    @user = create(:user)
    @recipe = create(:recipe, user_id: @user.id)
  end
  describe '#edit' do
    context 'レシピ作者とログインユーザーが一致する場合' do
      before do
        session[:user_id] = @user.id
        @steps = create_list(:step, 2, recipe_id: @recipe.id)
        get :edit, params: { recipe_id: @recipe.id }
      end
      it '200レスポンスが返る' do
        expect(response.status).to eq(200)
      end
      it '@stepsにリクエストされたレシピのstepsを割り当てる' do
        expect(assigns(:steps)).to include(@steps[1])
      end
      it '@stepsのrecipe_idには@recipeのidが登録される' do
        expect(assigns(:steps)).to all(have_attributes(recipe_id: @recipe.id))
      end
      it '@stepsの要素数は10' do
        expect(assigns(:steps).size).to eq 10
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
      @new_steps = attributes_for_list(:step, 3)
    end
    context 'レシピ作者とログインユーザーが一致する場合' do
      before do
        @orig_steps = create_list(:step, 2, recipe_id: @recipe.id)
        session[:user_id] = @user.id
      end
      context '有効なパラメータの場合' do
        before do
          @steps = @new_steps + attributes_for_list(:step, 7, number: nil, content: nil)
        end
        it '302レスポンスが返る' do
          patch :update, params: { steps: @steps, recipe_id: @recipe.id }
          expect(response.status).to eq 302
        end
        it '@stepsのrecipe_idに@recipeのidを割り当てる' do
          patch :update, params: { steps: @steps, recipe_id: @recipe.id }
          expect(assigns(:steps)).to all(have_attributes(recipe_id: @recipe.id))
        end
        it '有効なパラメータを持つstepのみ、データベースに登録される' do
          expect  do
            patch :update, params: { steps: @steps, recipe_id: @recipe.id }
          end.to change(@recipe.steps, :count).by(@new_steps.size - @orig_steps.size)
        end
        it '手順編集画面にリダイレクトする' do
          patch :update, params: { steps: @steps, recipe_id: @recipe.id }
          expect(response).to redirect_to recipe_url(@recipe)
        end
      end
      context '無効なパラメータを含む場合(contentが60文字より長い)' do
        before do
          text = 'a' * 61
          @new_steps << attributes_for(:step, content: text)
        end
        it '200レスポンスが返る' do
          patch :update, params: { steps: @new_steps, recipe_id: @recipe.id }
          expect(response.status).to eq 200
        end
        it 'データベースは変更されない' do
          expect  do
            patch :update, params: { steps: @new_steps, recipe_id: @recipe.id }
          end.not_to change(@recipe.steps, :count)
        end
        it ':newテンプレートを再表示する' do
          patch :update, params: { steps: @new_steps, recipe_id: @recipe.id }
          expect(response).to render_template :edit
        end
      end
    end
    context 'レシピ作者とログインユーザーが一致しない場合' do
      before do
        @login_user = create(:user)
        session[:user_id] = @login_user.id
        patch :update, params: { steps: @new_steps, recipe_id: @recipe.id }
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
