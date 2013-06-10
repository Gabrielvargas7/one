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

class Notification < ActiveRecord::Base
  attr_accessible :image_name, :name, :user_id,:description ,:position

  mount_uploader :image_name, NotificationsImageUploader

  has_many :users_notifications

  validates :name, presence: true
  validates :position,presence:true, numericality: { only_integer: true }
  validates :user_id, numericality: { only_integer: true }




end
