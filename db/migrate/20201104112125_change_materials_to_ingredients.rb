class ChangeMaterialsToIngredients < ActiveRecord::Migration[5.2]
  def change
    rename_table :materials, :ingredients
  end
end
