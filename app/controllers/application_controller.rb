class ApplicationController < ActionController::Base




  #Force to signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end


  private

  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper

end
