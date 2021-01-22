class ChangeDataTypeRecipes < ActiveRecord::Migration[5.2]
  def change
    change_column :recipes, :explanation, :string
    change_column :recipes, :homepage, :text
  end
end
