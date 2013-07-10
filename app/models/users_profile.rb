class UsersProfile < ActiveRecord::Base
  attr_accessible :birthday, :city, :country, :description, :firstname, :gender, :lastname, :user_id


  belongs_to :user

  validates_presence_of :user


end
