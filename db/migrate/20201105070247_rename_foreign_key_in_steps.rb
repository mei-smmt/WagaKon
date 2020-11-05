class RenameForeignKeyInSteps < ActiveRecord::Migration[5.2]
  def change
    remove_reference :steps, :article
    add_reference :steps, :recipe, foreign_key: true
  end
end
