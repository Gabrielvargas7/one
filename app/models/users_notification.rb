class UsersNotification < ActiveRecord::Base
  attr_accessible :notification_id, :notified, :user_id
end
