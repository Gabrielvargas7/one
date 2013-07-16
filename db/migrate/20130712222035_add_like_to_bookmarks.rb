class AddLikeToBookmarks < ActiveRecord::Migration
  def change
    add_column :bookmarks, :like, :integer
  end
end
