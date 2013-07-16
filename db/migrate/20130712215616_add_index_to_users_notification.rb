class AddIndexToUsersNotification < ActiveRecord::Migration
  def change
     add_index :notifications, :name
     add_index :notifications, :description
         add_index :notifications, :position
         add_index :notifications, :user_id


  end
end
