class RemoveImageFromSteps < ActiveRecord::Migration[5.2]
  def change
    remove_column :steps, :image
  end
end
