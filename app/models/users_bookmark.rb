class UsersBookmark < ActiveRecord::Base
  attr_accessible :bookmark_id, :user_id

  belongs_to :bookmark
  belongs_to :user


end
