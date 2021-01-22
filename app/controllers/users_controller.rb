class UsersController < ApplicationController
  before_action :require_user_logged_in, except: [:new, :create]
  before_action :prepare_search, except: [:new, :create]
  before_action :prepare_meals, except: [:new, :create]
  before_action :set_current_user, except: [:show, :new, :create]

  def show
    accessable_user_check
    recipes = @user == current_user ? @user.recipes : @user.recipes.published
    @recipes = recipes.page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.except(:remove_img))
    if @user.save
      (0..6).each { |index| @user.meals.create(day_of_week: index) }
      login(@user.email, @user.password)
      flash[:success] = '登録しました'
      redirect_to root_url
    else
      render :new
    end
  end
  
  def edit
  end
  
  def render_edit
    render :edit
  end
  
  def update
    if User.safe_update(@user, user_params)
      flash[:success] = 'プロフィールが更新されました'
      redirect_to @user
    else
      @user.errors.add(:base, "パスワードが間違っています") if @user.errors.blank?
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = 'アカウントが削除されました'
    redirect_to root_url
  end
  
  def password_edit
  end
  
  def password_update
    if User.safe_password_update(@user, password_params)
      flash[:success] = 'パスワードが更新されました'
      redirect_to @user
    else
      @user.errors.add(:base, "現在のパスワードが間違っています") if @user.errors.blank?
      render :password_edit
    end
  end
  
  def friends
  end
  
  def search
    @result_user = User.search(params[:search]) unless params[:search] == ""
    render :friends
  end
  
  def favorite_recipes
    recipes = @user.favorite_recipes & @user.accessable_recipes
    @recipes = Kaminari.paginate_array(recipes).page(params[:page])
  end 

  private

  def user_params
    params.require(:user).permit(:name, :personal_id, :email, :image, :remove_img, :password, :password_confirmation)
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
  
  def set_current_user
    @user = current_user
  end
  
  def accessable_user_check
    @user = User.find(params[:id])
    unless @user == current_user || current_user.approved_friends.include?(@user)
      redirect_to root_url
    end
  end
end
