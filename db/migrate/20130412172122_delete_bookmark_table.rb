class DeleteBookmarkTable < ActiveRecord::Migration
  def up
    drop_table :bookmarks
  end

  def down
  end
end
