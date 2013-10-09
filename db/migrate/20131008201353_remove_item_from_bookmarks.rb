class RemoveItemFromBookmarks < ActiveRecord::Migration
  def up
    remove_column :bookmarks, :item_id
  end

  def down
    add_column :bookmarks, :item_id, :string
  end
end
