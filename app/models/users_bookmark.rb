# == Schema Information
#
# Table name: users_bookmarks
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  bookmark_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position    :integer
#

class UsersBookmark < ActiveRecord::Base
  attr_accessible :bookmark_id, :user_id, :position

  belongs_to :bookmark
  belongs_to :user

  validates_presence_of :user
  validates_presence_of :bookmark

  validates :user_id,presence:true, numericality: { only_integer: true }
  validates :bookmark_id,presence:true, numericality: { only_integer: true }



end
