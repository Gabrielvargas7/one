class StaticPagesController < ApplicationController

  # This action uses the signed_in? method from sessions_helper
  # to see if the user is signed in.
  def home
    if signed_in?
      # Question
      # What is `current_user` (helper method? global variable?)
      redirect_to room_rooms_path(current_user.username)
    end

    # Within what scope are this properties visible? Is it the corresponding view?
    @landing_page_view = true
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
