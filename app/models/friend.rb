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

  before_create :user_id_friend_exist

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


end
