class AddDescriptionToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :description, :text
  end
end
