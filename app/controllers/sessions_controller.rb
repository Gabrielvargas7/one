class SessionsController < ApplicationController

  def new

  end
  def create

    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.

      sign_in user
      redirect_back_or user
      #redirect_to user



    else
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end

  end

  def destroy
    sign_out
    redirect_to root_url
  end



  def create_facebook
    auth = env["omniauth.auth"]
    email = auth.extra.raw_info.email

    # if the user exist, check it is a facebook user
    if User.exists?(email:email)
      user = User.find_by_email(email)

      if user.uid.blank? then
      # this user is already on the system with room login
        flash.now[:error] = 'Invalid email/password combination' # Not quite right!
        render 'new'
      else
       # this user is on the system with facebook login (login fine)
        user = User.from_omniauth(env["omniauth.auth"])

        sign_in user
        redirect_back_or user
      end
    else
      #this user is new
      user = User.from_omniauth(env["omniauth.auth"])

      sign_in user
      redirect_back_or user

    end
  end
end
