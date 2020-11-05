class RenameForeignKeyInBookmarks < ActiveRecord::Migration[5.2]
  def change
    remove_reference :bookmarks, :article
    add_reference :bookmarks, :recipe, foreign_key: true
  end
end
