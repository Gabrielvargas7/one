class ChangeApprovedAndAddBookmarksOfUserToBookmarks < ActiveRecord::Migration
  def up
    add_column :bookmarks, :bookmark_of_user, :integer ,:default => 0
    change_column :bookmarks, :approval, :string,:default => 'y'
  end

  def down
  end
end
