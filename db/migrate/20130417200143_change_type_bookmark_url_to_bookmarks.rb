class ChangeTypeBookmarkUrlToBookmarks < ActiveRecord::Migration
  def up
    change_column :bookmarks, :bookmark_url, :text
  end

  def down
  end
end
