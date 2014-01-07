class StaticPagesController < ApplicationController
  def home
    if signed_in?
      redirect_to room_rooms_path(current_user.username)
    end

    @landing_page_view=true
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
end
