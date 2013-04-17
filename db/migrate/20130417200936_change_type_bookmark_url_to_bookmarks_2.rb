class ChangeTypeBookmarkUrlToBookmarks2 < ActiveRecord::Migration
  def up
    change_column :bookmarks, :bookmark_url, :text, :limit => nil
  end

  def down
  end
end
