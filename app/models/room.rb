class Room < ActiveRecord::Base
  attr_accessible :item_id, :theme_id, :user_id
end
