class ApplicationController < ActionController::Base

  before_filter :ensure_domain

  APP_DOMAIN = 'www.mywebroom.com'
  #HEROKU_APP_DOMAIN = 'sleepy-scrubland-1880.herokuapp.com'
  HEROKU_APP_DOMAIN = 'staging-mywebroom.herokuapp.com'

  def ensure_domain
    if request.env['HTTP_HOST'] == HEROKU_APP_DOMAIN
      # HTTP 301 is a "permanent" redirect
      redirect_to "http://#{APP_DOMAIN}", :status => 301
    end
  end

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
  include RoomsHelper

end
