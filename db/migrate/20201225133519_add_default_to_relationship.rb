class AddDefaultToRelationship < ActiveRecord::Migration[5.2]
  def up
    change_column :relationships, :status, :integer, default: 0
  end

  def down
    change_column :relationships, :status, :integer
  end
end
