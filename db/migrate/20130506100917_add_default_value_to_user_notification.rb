class AddDefaultValueToUserNotification < ActiveRecord::Migration

  def self.up
    change_column_default :users_notifications, :notification_id, 0

  end

  def self.down

  end
end
