class SessionsController < ApplicationController

  def new
    @skip_login = true
    @skip_signup = true
  end



  def create

    if User.exists?(email:params[:session][:email].downcase)
       user = User.find_by_email(params[:session][:email].downcase)

       @user_profile = UsersProfile.find_by_user_id(user.id)

       # this is temporal for the old user of the old server and only one time
       if @user_profile.password_reset_on_login?

             ActiveRecord::Base.transaction do
               begin
                 @user_profile.password_reset_on_login = false
                 user.password  = params[:session][:password]

                 @user_profile.save
                 user.save

                 sign_in user
                 verified_and_insert_new_item_to_user user
                 redirect_back_or user


               rescue ActiveRecord::StatementInvalid
                 flash.now[:error] = 'Invalid email/password combination' # Not quite right!
                 @skip_login = true
                 render 'new'

               end
             end
       else

            if user && user.authenticate(params[:session][:password])
              # Sign the user in and redirect to the user's show page.

              sign_in user
              verified_and_insert_new_item_to_user user
              redirect_back_or user
              #redirect_to user

            else
              flash.now[:error] = 'Invalid email/password combination' # Not quite right!
              @skip_login = true
              render 'new'
            end

       end

    else
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      @skip_login = true
      render 'new'
    end

  end







  def destroy
    sign_out
    redirect_to root_url
  end



  def create_facebook
    #puts "create facebook cookies facebook: "+cookies[:facebook_bundle_id].to_s
    auth = env["omniauth.auth"]
    email = auth.extra.raw_info.email

    # if the user exist, check it is a facebook user
    if User.exists?(email:email)
      user = User.find_by_email(email)
      #user.specific_room_id = cookies[:facebook_bundle_id]

      #puts "user cookies facebook: "+user.specific_room_id.to_s

      if user.uid.blank? then
      # this user is already on the system with room login
        flash.now[:error] = 'Invalid email/password combination' # Not quite right!
        @skip_login = true
        render 'new'
      else

        # this user is on the system with facebook login (login fine)
        user = User.from_omniauth(env["omniauth.auth"],'')

        sign_in user
        verified_and_insert_new_item_to_user user
        redirect_back_or user
      end
    else
      user = User.from_omniauth(env["omniauth.auth"],cookies[:facebook_bundle_id])
      sign_in user
      redirect_back_or user

    end
  end

  def verified_and_insert_new_item_to_user(user)

        @items_locations = ItemsLocation.all

        @items_locations.each do |item_location|

          unless UsersItemsDesign.joins(:items_design).where('user_id = ? and items_designs.item_id =? and location_id = ?',user.id,item_location.item_id,item_location.location_id).exists?
            if ItemsDesign.exists?(item_id:item_location.item_id)
              @item_design = ItemsDesign.find_by_item_id(item_location.item_id)
              UsersItemsDesign.create(items_design_id:@item_design.id, user_id:user.id,hide:"no" ,location_id:item_location.location_id)
            end
          end
        end
  end
end
