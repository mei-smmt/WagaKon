class AddColumnRecipe < ActiveRecord::Migration[5.2]
  def change
    add_column :recipes, :homepage, :string
  end
end
