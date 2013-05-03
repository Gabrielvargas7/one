class CreateUsersNotifications < ActiveRecord::Migration
  def change
    create_table :users_notifications do |t|
      t.integer :user_id
      t.integer :notification_id
      t.string :notified ,:null => false, :default => 'y'

      t.timestamps
    end
  end
end
