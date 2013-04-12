class DeleteBookmarkCategoryTable < ActiveRecord::Migration
  def up
    drop_table :bookmarks_categories
  end

  def down
  end
end
