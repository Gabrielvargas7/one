class ApplicationController < ActionController::Base


  # add this lines on the production server
  if Rails.env.production?
      #Force to signout to prevent CSRF attacks
      def handle_unverified_request
        sign_out
        super
      end
  end


  private

  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper

end
