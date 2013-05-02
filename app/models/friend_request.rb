class FriendRequest < ActiveRecord::Base
  attr_accessible :user_id, :user_id_requested
end
