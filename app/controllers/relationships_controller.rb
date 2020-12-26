class RelationshipsController < ApplicationController
before_action :require_user_logged_in

  def create
    @user = User.find(params[:user_id])
    current_user.friend_request(@user)
    redirect_to friends_user_url(current_user)
  end

  def update
    @user = User.find(params[:user_id])
    current_user.friend_approve(@user)
    redirect_to friends_user_url(current_user)
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.friend_delete(@user)
    redirect_to friends_user_url(current_user)
  end
end
