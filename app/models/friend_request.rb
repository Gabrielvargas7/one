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


  before_create :user_id_requested_exist

  belongs_to :user
  validates_presence_of :user

  validates :user_id,presence:true, numericality: { only_integer: true }
  validates :user_id_requested,presence:true, numericality: { only_integer: true }

  def user_id_requested_exist

     #check is the user request exist if not (don't save)
     if User.exists?(id:self.user_id_requested)
        true
      else
        false
     end
  end



end
