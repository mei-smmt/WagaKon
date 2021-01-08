class AddColumRecipes < ActiveRecord::Migration[5.2]
  def change
    add_column :recipes, :size, :string
  end
end
