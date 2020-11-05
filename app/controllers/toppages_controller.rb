class ToppagesController < ApplicationController
  def index
    @recipes = Recipe.published
  end
end
