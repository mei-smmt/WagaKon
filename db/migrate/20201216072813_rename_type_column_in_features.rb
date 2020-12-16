class RenameTypeColumnInFeatures < ActiveRecord::Migration[5.2]
  def change
    rename_column :features, :type, :dish_type
  end
end
