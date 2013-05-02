class AddIndexToBundlesBookmarks < ActiveRecord::Migration

  def self.up
    add_index :bundles_bookmarks, :id
    add_index :bundles_bookmarks, :item_id
    add_index :bundles_bookmarks, :bookmark_id

  end

  def self.down
    remove_index :bundles_bookmarks, :id
    remove_index :bundles_bookmarks, :item_id
    remove_index :bundles_bookmarks, :bookmark_id
  end

end
