class AddPositionToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :position, :integer
  end
end
