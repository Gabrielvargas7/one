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

  validate :friend_exists
  validate :user_profile_exists
  validate :friend_and_user_are_not_same


  before_create :add_one_friend

  belongs_to :user
  validates_presence_of :user


  validates :user_id,presence:true, numericality: { only_integer: true }
  validates :user_id_friend,presence:true, numericality: { only_integer: true }




  def friend_exists
    errors.add(:user_id_friend, "friend does not exist") unless User.exists?(id: self.user_id_friend)
  end



  def user_profile_exists
    errors.add(:user_id, "user does not have a profile") unless UsersProfile.exists?(user_id: self.user_id)
  end



  def add_one_friend
    @user_profile = UsersProfile.find_all_by_user_id(self.user_id).first
    @user_profile.friends_number += 1
    @user_profile.save!
  end



  def friend_and_user_are_not_same
    errors.add(:base, "friend and user cannot be the same") unless self.user_id_friend != self.user_id
  end



end
