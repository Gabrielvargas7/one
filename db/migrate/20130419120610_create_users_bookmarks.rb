class CreateUsersBookmarks < ActiveRecord::Migration
  def change
    create_table :users_bookmarks do |t|
      t.integer :user_id
      t.integer :bookmark_id

      t.timestamps
    end
  end
end
