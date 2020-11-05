class ApplicationController < ActionController::Base
  
  include SessionsHelper
  
   private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def user_author_match(pa)
    @recipe = Recipe.find(pa)
    @user = @recipe.user
    unless @user == current_user
      redirect_to root_url
    end
  end  

end
