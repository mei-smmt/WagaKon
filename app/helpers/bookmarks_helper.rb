module BookmarksHelper
  def favorite?(user, recipe)
    user.favorite_recipes.include?(recipe)
  end
end
