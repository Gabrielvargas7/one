class CreateBookmarkLikes < ActiveRecord::Migration
  def change
    create_table :bookmark_likes do |t|
      t.integer :user_id
      t.integer :bookmark_id

      t.timestamps
    end

    add_index :bookmark_likes, :user_id
    add_index :bookmark_likes, :bookmark_id
    add_index :bookmark_likes, [:user_id, :bookmark_id], unique: true
  end
end
