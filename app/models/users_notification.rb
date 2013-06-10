# == Schema Information
#
# Table name: users_notifications
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  notification_id :integer          default(0)
#  notified        :string(255)      default("y"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class UsersNotification < ActiveRecord::Base
  attr_accessible :notification_id, :notified, :user_id

  belongs_to :user
  belongs_to :notification


  validates_presence_of :user
  #no need to be present
  #validates_presence_of :notification

  VALID_Y_N_REGEX = /(y)|(n)/

  validates :user_id,presence:true, numericality: { only_integer: true }
  validates :notification_id,presence:true, numericality: { only_integer: true }
  validates :notified, presence:true, format: { with: VALID_Y_N_REGEX }

end
