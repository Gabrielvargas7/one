module RoomsHelper

  def set_room_user user
      cookies.permanent[:room_user_token] = user.username
      self.room_user=user
  end

  #Set room_user
  def room_user=(user)
    @room_user = user
  end

  #Get room_username if null get empty string
  def room_user
    @room_user ||= User.find_by_username(cookies[:room_user_token])

  end

  #check if the username is room_username
  def room_user?(user)
    user == room_user
  end


end
