class RemoveProfileFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :profile
  end
end
