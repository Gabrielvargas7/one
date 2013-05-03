class Notification < ActiveRecord::Base
  attr_accessible :image_name, :name, :user_id

  mount_uploader :image_name, NotificationsImageUploader
end
