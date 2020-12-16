class CreateFeatures < ActiveRecord::Migration[5.2]
  def change
    create_table :features do |t|
      t.integer :amount
      t.integer :type
      t.integer :cooking_method
      t.integer :main_food
      t.references :recipe, foreign_key: true
      t.timestamps
    end
  end
end
