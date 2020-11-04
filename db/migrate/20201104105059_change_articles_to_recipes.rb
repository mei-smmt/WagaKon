class ChangeArticlesToRecipes < ActiveRecord::Migration[5.2]
  def change
    rename_table :articles, :recipes
  end
end
