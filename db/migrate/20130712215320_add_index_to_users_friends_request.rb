class AddIndexToUsersFriendsRequest < ActiveRecord::Migration
  def change
    add_index :friend_requests, :user_id
    add_index :friend_requests, :user_id_requested
  end
end
