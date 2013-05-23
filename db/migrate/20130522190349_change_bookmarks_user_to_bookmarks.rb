class ChangeBookmarksUserToBookmarks < ActiveRecord::Migration
  def up
    rename_column :bookmarks, :bookmark_of_user, :user_bookmark
  end

  def down
  end
end
