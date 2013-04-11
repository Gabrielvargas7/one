class AddItemIdToBookmarks < ActiveRecord::Migration
  def change
    add_column :bookmarks, :item_id, :integer
  end
end
