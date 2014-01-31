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


  validate :friend_exists
  validate :friend_and_user_are_not_same

  belongs_to :user
  validates_presence_of :user

  validates :user_id,presence:true, numericality: { only_integer: true }
  validates :user_id_requested,presence:true, numericality: { only_integer: true }

  def friend_exists
    errors.add(:user_id_friend, "friend does not exist") unless User.exists?(id: self.user_id_requested)
  end

  def friend_and_user_are_not_same
    errors.add(:base, "friend and user cannot be the same") unless self.user_id_requested != self.user_id
  end



end
