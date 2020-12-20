class AddColumnUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :personal_id, :string
  end
end
