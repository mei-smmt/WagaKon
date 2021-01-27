class RelationshipsController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_friend

  def create
    current_user.friend_request(@friend)
    redirect_to friends_users_url
  end

  def update
    current_user.friend_approve(@friend)
    redirect_to friends_users_url
  end

  def destroy
    current_user.friend_delete(@friend)
    redirect_to friends_users_url
  end

  private

  def set_friend
    @friend = User.find(params[:user_id])
  end
end
