class RemoveItemFromBundleBookmarks < ActiveRecord::Migration
  def up
    remove_column :bundles_bookmarks, :item_id
  end

  def down
    add_column :bundles_bookmarks, :item_id, :string
  end
end
