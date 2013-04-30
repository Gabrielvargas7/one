class AddPositionToUsersBookmark < ActiveRecord::Migration
  def change
    add_column :users_bookmarks, :position, :integer
  end
end
