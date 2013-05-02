class AddIndexToBookmark < ActiveRecord::Migration

  def self.up
    add_index :bookmarks, :id
    add_index :bookmarks, :bookmarks_category_id
    add_index :bookmarks, :item_id
    add_index :bookmarks, :bookmark_url
    add_index :bookmarks, :title

  end

  def self.down
    remove_index :bookmarks, :id
    remove_index :bookmarks, :bookmarks_category_id
    remove_index :bookmarks, :item_id
    remove_index :bookmarks, :bookmark_url
    remove_index :bookmarks, :title
  end


end
