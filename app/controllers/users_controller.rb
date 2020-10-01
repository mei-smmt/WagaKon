class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
     @user = User.new(user_params)

    if @user.save
      flash[:success] = '登録しました'
      redirect_to root_url
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = 'ユーザー情報が更新されました'
      redirect_to @user
    else
      flash.now[:danger] = '内容に誤りがあります'
      render :edit
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :profile, :password, :password_confirmation)
  end
end
