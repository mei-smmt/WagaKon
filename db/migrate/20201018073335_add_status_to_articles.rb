class AddStatusToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :article, :status, :integer, default: 0
  end
end
