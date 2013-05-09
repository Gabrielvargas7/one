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
end
