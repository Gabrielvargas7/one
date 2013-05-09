# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  image_name  :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#  position    :integer
#

# == Schema Information
#
# Table name:
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id   (this user is who create the notification)
#
class Notification < ActiveRecord::Base
  attr_accessible :image_name, :name, :user_id,:description ,:position

  mount_uploader :image_name, NotificationsImageUploader
end
