class UsersController < ApplicationController


  # Create and new user should not be filter because
  # is when a new user sign up


  before_filter :signed_in_user,
    only:[
        :edit,
        :update,
        :destroy,
        :show,
        :index]

  before_filter :json_signed_in_user,
    only:[
        :json_update_username_by_user_id,
        :json_show_user_profile_by_user_id,
        :json_create_user_full_bundle_by_user_id_and_bundle_id,
        :json_update_users_image_profile_by_user_id,
        :json_show_signed_user
        ]

  before_filter :json_correct_user,
                only:[
                    :json_update_username_by_user_id,
                    :json_show_user_profile_by_user_id,
                    :json_create_user_full_bundle_by_user_id_and_bundle_id,
                    :json_update_users_image_profile_by_user_id

                ]


  before_filter :correct_user, only:[:edit,:update,:show]
  before_filter :admin_user, only:[:destroy,:index]


  def show

       if User.exists?(id:params[:id])

          @user = User.find(params[:id])
          #redirect_to room_rooms_url @user.username

           respond_to do |format|
             format.html # show.html.erb
             format.json { render json: @user.as_json(only:[:name,:email,:username])  }
           end

       else
          redirect_to(root_path)
       end

  end

  def new
    @user = User.new
  end
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the MyWebRoom!"
      #redirect_to @user

      redirect_back_or @user
      # Handle a successful save.
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # Handle a successful update.
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end


  def index

    @users = User.paginate(page: params[:page])

  end


  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url

  end

  #***********************************
  # Json methods for the room users
  #***********************************

  #//# PUT update the username
  #//#  /users/json/update_username_by_user_id/:user_id'
  #//#  /users/json/update_username_by_user_id/1000.json
  #//#  Form Parameters:
  #//#                  :new_username
  #Return ->
  #success    ->  head  200 ok

  def json_update_username_by_user_id

    respond_to do |format|
      #validate if the user exist
      if User.exists?(id:params[:user_id])

          new_username = clean_username(params[:new_username])
          new_username_downcase =  params[:new_username]
          new_username_downcase.downcase!

          # validate the username has to be only alphanumeric characters,therefore,
          # if change after clean, mean that it have no valid characters
          if new_username.eql?(new_username_downcase)

            # validate the username has to be unique
            if User.exists?(username: new_username)
              format.json { render json: 'sorry but the username is already take' , status: :conflict }
            else
              @user = User.find(params[:user_id])
                if @user.update_attributes(username:new_username)
                  #format.json { head :no_content }
                  format.json { render json: @user.as_json(only: [:id,:username]), status: :ok }
                else
                  format.json { render json: @user.errors, status: :unprocessable_entity }
                end
            end
          else
            format.json { render json: 'invalid username ,only alphanumerical characters ' , status: :not_acceptable }
          end
      else
        format.json { render json: 'not found user id' , status: :not_found }
      end

    end
  end


  # GET get user profile
  #  /users/json/show_user_profile_by_user_id/:user_id
  #  /users/json/show_user_profile_by_user_id/206.json
  #  /# success    ->  head  200 OK

  def json_show_user_profile_by_user_id
    @user = User.find(params[:user_id])

    respond_to do |format|
      format.json { render json: @user.as_json(only:[:name,:email,:username,:image_name])  }
    end
  end

  # POST set full bundle to the user
  #  set theme, items design to the users, and delete the old one
  #  /users/json/create_user_full_bundle_by_user_id_and_bundle_id/:user_id/:bundle_id
  #  /users/json/create_user_full_bundle_by_user_id_and_bundle_id/206/10.json
  #  /# success    ->  head  200 OK

  def json_create_user_full_bundle_by_user_id_and_bundle_id


    respond_to do |format|

      if User.exists?(id:params[:user_id])
         if Bundle.exists?(id:params[:bundle_id])

            @user = User.find(params[:user_id])
            @bundle = Bundle.find(params[:bundle_id])
            @bundles_items_designs = BundlesItemsDesign.find_all_by_bundle_id(params[:bundle_id])
            @locations = Location.find_all_by_section_id(@bundle.section_id)


           # delete any item design of the user
           # delete the theme of the user
           # create the new items_design for the user
           # create the new theme
           ActiveRecord::Base.transaction do
             begin


               @locations.each do |location|
                  UsersItemsDesign.where("user_id = ? and location_id = ?",params[:user_id],location.id).delete_all
               end

               UsersTheme.where("user_id = ? and section_id = ?",params[:user_id],@bundle.section_id).delete_all

               @user_theme = UsersTheme.new(user_id:params[:user_id],theme_id:@bundle.theme_id,section_id:@bundle.section_id)
               @user_theme.save

               @bundles_items_designs.each  do |bundles_items_design|

                 @user_items_design = UsersItemsDesign.new(user_id:params[:user_id],items_design_id:bundles_items_design.items_design_id, hide:'no',location_id:bundles_items_design.location_id)
                 @user_items_design.save
               end
               @users_items_design = UsersItemsDesign.select("users_items_designs.*,locations.section_id").where("user_id = ?",params[:user_id]).joins(:location).all

               format.json { render json: {user_theme: @user_theme, users_items_design:@users_items_design}, status: :ok }

             rescue
               format.json { render json: 'failure creating new full bundle for the user', status: :unprocessable_entity }
               raise ActiveRecord::Rollback
             end

           end
         else
           format.json { render json: 'not found bundle id' , status: :not_found }
         end
      else
        format.json { render json: 'not found user id' , status: :not_found }
      end
    end

  end


  # PUT insert user image
  #/users/json/update_users_image_profile_by_user_id/:user_id
  #/users/json/update_users_image_profile_by_user_id/206.json
  # Content-Type : multipart/form-data
  # Form Parameters:
  #               :image_name (full path)
  #Return ->
  #success    ->  head  201 create
  def json_update_users_image_profile_by_user_id

    respond_to do |format|
      #validation of the user_id

      if User.exists?(id: params[:user_id])

        @user = User.find(params[:user_id])

        if @user.update_attribute(:image_name, params[:image_name])
          format.json { render json: @user.as_json(only:[:id,:image_name,:name] ), status: :ok }
        else
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        format.json { render json: 'user not found' , status: :not_found }
      end

    end

  end

  # GET get signed user info
  #  /users/json/show_signed_user
  #  /users/json/show_signed_user
  #  /# success    ->  head  200 OK

  def json_show_signed_user
    @current_user =  current_user
    respond_to do |format|
      if @current_user.nil?
        format.json { render json: 'user not found' , status: :not_found }
      else
        format.json { render json: @current_user.as_json(only:[:id,:image_name,:name,:username]), status: :ok}
      end


    end
  end



  #***********************************
  # End Json methods for the room users
  #***********************************


  private



  # this function will remove all non-alphanumeric character and
  # replace the empty space for dash eg 'my new username@@' = my-new-username
  def clean_username(username)

    my_username = username
    #remove all non- alphanumeric character (expect dashes '-')
    my_username = my_username.gsub(/[^0-9a-z -]/i, '')

    #remplace dashes() for empty space because if the user add dash mean that it want separate the username
    my_username = my_username.gsub(/[-]/i, ' ')

    #remplace the empty space for one dash by word
    my_username.downcase!
    my_username.strip!
    username_split = my_username.split(' ').join('-')

  end



end
