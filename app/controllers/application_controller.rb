class ApplicationController < ActionController::Base
  
  include SessionsHelper
  
   private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def user_author_match(pa)
    @article = Article.find(pa)
    @user = @article.user
    unless @user == current_user
      redirect_to root_url
    end
  end  

end
