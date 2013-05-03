class Feedback < ActiveRecord::Base
  attr_accessible :description, :email, :name, :user_id
end
