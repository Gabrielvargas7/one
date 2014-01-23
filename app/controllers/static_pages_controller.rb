class StaticPagesController < ApplicationController

  # This action uses the signed_in? method from sessions_helper
  # to see if the user is signed in.

  # Called when a user navigates to root
  def home
    if signed_in?

      redirect_to room_rooms_path(current_user.username)


    end

    # These are variables available to our views
    # Within application.html.erb, there's a statement that
    # checks to see if these values are set.
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
