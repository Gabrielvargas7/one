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

require 'spec_helper'

describe FriendRequest do
  pending "add some examples to (or delete) #{__FILE__}"
end
