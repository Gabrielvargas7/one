# == Schema Information
#
# Table name: friend_requests
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  user_id_requested :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class FriendRequest < ActiveRecord::Base
  attr_accessible :user_id, :user_id_requested
end
