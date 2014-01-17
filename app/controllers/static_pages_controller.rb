class StaticPagesController < ApplicationController

  # This action uses the signed_in? method from sessions_helper
  # to see if the user is signed in.

  # It is called when a user navigates to root
  def home
    if signed_in?
      # Question
      # What is `current_user` (helper method? global variable?)
      redirect_to room_rooms_path(current_user.username) # could we pass in a flag here that indicated we were in our own room?


    end

    # These are variables available to application.html.erb (any other pages?)
    # Within application.html.erb, there's a statement that checks to see if this
    # value is set.
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
