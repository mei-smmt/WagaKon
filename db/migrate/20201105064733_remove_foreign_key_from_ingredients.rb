class RemoveForeignKeyFromIngredients < ActiveRecord::Migration[5.2]
  def change
    remove_reference :ingredients, :article
  end
end
