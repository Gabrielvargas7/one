class StaticPagesController < ApplicationController
  def home
    if signed_in?
      redirect_to room_rooms_path(current_user.username)
    end


    @skip_header = true
    @skip_footer = true
  end

  def help
  end
  def about
    @skip_container = true
    @skip_header = false
    @skip_footer = false
  end
  def contact
  end
end
