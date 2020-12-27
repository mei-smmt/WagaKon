class RelationshipsController < ApplicationController
before_action :require_user_logged_in

  def create
    @friend = User.find(params[:user_id])
    current_user.friend_request(@friend)
    redirect_to friends_user_url(current_user)
  end

  def update
    @friend = User.find(params[:user_id])
    current_user.friend_approve(@friend)
    redirect_to friends_user_url(current_user)
  end

  def destroy
    @friend = User.find(params[:user_id])
    current_user.friend_delete(@friend)
    redirect_to friends_user_url(current_user)
  end
end
