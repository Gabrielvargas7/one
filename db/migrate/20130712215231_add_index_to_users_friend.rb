class AddIndexToUsersFriend < ActiveRecord::Migration
  def change
    add_index :friends, :user_id
    add_index :friends, :user_id_friend
  end
end
