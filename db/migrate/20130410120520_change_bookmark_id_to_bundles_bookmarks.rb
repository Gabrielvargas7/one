class ChangeBookmarkIdToBundlesBookmarks < ActiveRecord::Migration
  def up
    change_column :bundles_bookmarks, :bookmark_id,:integer
  end

  def down
    change_column :bundles_bookmarks, :bookmark_id,:string
  end
end
