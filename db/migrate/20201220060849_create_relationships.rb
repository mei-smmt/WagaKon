class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.references :user, foreign_key: true
      t.references :friend, foreign_key: { to_table: :users }
      t.integer :status
      
      t.timestamps
      
      t.index [:user_id, :friend_id], unique: true
    end
  end
end
