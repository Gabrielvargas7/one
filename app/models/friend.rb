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

  before_create :user_id_friend_exist,:add_one_friend

  belongs_to :user
  validates_presence_of :user



  validates :user_id,presence:true, numericality: { only_integer: true }
  validates :user_id_friend,presence:true, numericality: { only_integer: true }

  def user_id_friend_exist
    #check is the user request exist if not (don't save)
    if User.exists?(id:self.user_id_friend)
        true
    else
      false
    end
  end


  def add_one_friend
    #check is the user request exist if not (don't save)
    if UsersProfile.exists?(user_id:self.user_id)
      @user_profile = UsersProfile.find_all_by_user_id(self.user_id).first
      @user_profile.friends_number+=1
      @user_profile.save!
    end
  end


end
