class Friend < ActiveRecord::Base
  attr_accessible :user_id, :user_id_friend

  belongs_to :user
end
