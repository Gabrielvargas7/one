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


end
