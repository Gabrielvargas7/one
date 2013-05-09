# == Schema Information
#
# Table name: friends
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  user_id_friend :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Friend < ActiveRecord::Base
  attr_accessible :user_id, :user_id_friend

  belongs_to :user
end
