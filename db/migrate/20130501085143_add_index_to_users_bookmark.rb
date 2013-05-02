class AddIndexToUsersBookmark < ActiveRecord::Migration

  def self.up
    add_index :users_bookmarks, :id
    add_index :users_bookmarks, :user_id
    add_index :users_bookmarks, :bookmark_id
    add_index :users_bookmarks, :position

  end

  def self.down
    remove_index :users_bookmarks, :id
    remove_index :users_bookmarks, :user_id
    remove_index :users_bookmarks, :bookmark_id
    remove_index :users_bookmarks, :position

  end

end
