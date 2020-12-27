class ToppagesController < ApplicationController
  before_action :require_user_logged_in  

  def index
    @recipes = current_user.accessable_recipes
  end
end
