# == Schema Information
#
# Table name: bookmark_likes
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  bookmark_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class BookmarkLike < ActiveRecord::Base
  attr_accessible :bookmark_id, :user_id

  validates :bookmark_id, presence: true
  validates :user_id, presence: true
end
