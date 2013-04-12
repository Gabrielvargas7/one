class DeleteBundlesBookmarkTable < ActiveRecord::Migration
  def up
    drop_table :bundles_bookmarks
  end

  def down
  end
end
