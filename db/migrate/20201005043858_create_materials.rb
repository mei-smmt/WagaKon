class CreateMaterials < ActiveRecord::Migration[5.2]
  def change
    create_table :materials do |t|
      t.string :name
      t.string :quantity
      t.references :recipe, foreign_key: true

      t.timestamps
    end
  end
end
