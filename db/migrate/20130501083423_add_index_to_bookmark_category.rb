class AddIndexToBookmarkCategory < ActiveRecord::Migration

  def self.up
    add_index :bookmarks_categories, :id
    add_index :bookmarks_categories, :item_id
    add_index :bookmarks_categories, :name

  end

  def self.down
    remove_index :bookmarks_categories, :id
    remove_index :bookmarks_categories, :item_id
    remove_index :bookmarks_categories, :name
  end

end
