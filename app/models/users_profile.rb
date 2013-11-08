class UsersProfile < ActiveRecord::Base
  attr_accessible :birthday,
                  :city,
                  :country,
                  :description,
                  :firstname,
                  :gender,
                  :lastname,
                  :user_id,
                  :friends_number,
                  :tutorial_step


  #before_save{ get_location}

  belongs_to :user

  validates_presence_of :user

  #Note To get the location, it should move to the controller or view
  def get_location
    #self.city = request.remote_ip
    #self.city = request.location.city
    #self.country = request.location.country_code
  end

end
