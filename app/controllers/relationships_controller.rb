class RelationshipsController < ApplicationController
before_action :require_user_logged_in
bofore_action :set_friend
after_action :redirect_user_page

  def create
    current_user.friend_request(@friend)
  end

  def update
    current_user.friend_approve(@friend)
  end

  def destroy
    current_user.friend_delete(@friend)
  end
  
  private
  
  def set_friend
    @friend = User.find(params[:user_id])
  end
  
  def redirect_user_page
    redirect_to friends_user_url(current_user)
  end

end
