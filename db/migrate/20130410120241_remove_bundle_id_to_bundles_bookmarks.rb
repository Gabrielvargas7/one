class RemoveBundleIdToBundlesBookmarks < ActiveRecord::Migration
  def up
    remove_column :bundles_bookmarks, :bundle_id
  end

  def down
    add_column :bundles_bookmarks, :bundle_id, :string
  end
end
