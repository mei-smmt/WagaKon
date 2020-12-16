class CreateMeals < ActiveRecord::Migration[5.2]
  def change
    create_table :meals do |t|
      t.references :user, foreign_key: true
      t.integer :day_of_week
      t.timestamps
    end
  end
end
