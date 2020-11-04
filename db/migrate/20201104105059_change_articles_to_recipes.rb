class ChangeRecipesToRecipes < ActiveRecord::Migration[5.2]
  def change
    rename_table :recipes, :recipes
  end
end
