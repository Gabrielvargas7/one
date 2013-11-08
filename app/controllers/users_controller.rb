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
        :json_show_user_profile_by_user_id,
        :json_create_user_full_bundle_by_user_id_and_bundle_id,
        :json_show_signed_user
        ]

  before_filter :json_correct_user,
                only:[
                    :json_show_user_profile_by_user_id,
                    :json_create_user_full_bundle_by_user_id_and_bundle_id

                ]


  before_filter :correct_user, only:[:edit,:show,:update]
  before_filter :admin_user, only:[:destroy,:index]


  def show

       if User.exists?(id:params[:id])

          @user = User.find(params[:id])
          #redirect_to room_rooms_url @user.username

           respond_to do |format|
             format.html # show.html.erb
             format.json { render json: @user.as_json(only:[:email,:username])  }
           end

       else
          redirect_to(root_path)
       end

  end

  def new
    @user = User.new

    if params[:bundle_id].blank?

    else
      @bundle_id = params[:bundle_id]
      cookies.permanent[:facebook_bundle_id] = @bundle_id

    end

  end
  def create
    @user = User.new(params[:user])
    if params[:bundle_id].blank?

    else
      @user.specific_room_id = params[:bundle_id]
      puts "Bundle id "+@user.specific_room_id.to_s
    end
    #puts "Bundle id specifit room"+@user.specific_room_id.to_s


    #puts "------------------------------------------"
    #puts  "this is the city "+ request.location.city
    #puts "------------------------------------------"
    ##@user.country = request.location.country_code

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
    user = User.find(params[:id])

    if user && user.authenticate(params[:user][:password])

       if user.username == params[:user][:username]
         # no changes on the username

         if @user.update_attributes(params[:user])
           # Handle a successful update.
           flash[:success] = "Profile updated"
           sign_in @user
           redirect_to @user
         else
           render 'edit'
         end

       else
         clean_username = user.get_username(params[:user][:username])

         if clean_username == params[:user][:username]

            params[:user][:username] = clean_username

            if @user.update_attributes(params[:user])
              # Handle a successful update.
              flash[:success] = "Profile updated"
              sign_in @user
              redirect_to @user
            else
              render 'edit'
            end

          else
            # no available username
            flash[:error] = "the username is not available: this one is avalable "+clean_username
            render 'edit'
          end
       end
    else
      flash[:success] = "password is not valid"
      render 'edit'
    end
  end


  def index

    @users = User.paginate(page: params[:page])

  end


  def destroy
    #User.find(params[:id]).destroy

    flash[:success] = "User destroyed."
    redirect_to users_url

  end


  # GET get user profile
  #  /users/json/show_user_profile_by_user_id/:user_id
  #  /users/json/show_user_profile_by_user_id/206.json
  #  /# success    ->  head  200 OK

  def json_show_user_profile_by_user_id
    @user = User.find(params[:user_id])

    respond_to do |format|
      format.json { render json: @user.as_json(only:[:email,:username])  }
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



  # GET get signed user info
  #  /users/json/show_signed_user
  #  /users/json/show_signed_user
  #  /# success    ->  head  200 OK

  def json_show_signed_user

    @current_user =  current_user
    respond_to do |format|
      #format.json { render json: @current_user.as_json(only:[:id,:username]), status: :ok}
      if @current_user.nil?
        format.json { render json: 'user not found' , status: :no_content }
      else
        format.json { render json: @current_user.as_json(only:[:id,:username]), status: :ok}
      end


    end
  end


  # GET get signed user info
  #  /users/json/is_signed_user
  #  /users/json/is_signed_user
  #  /# success    ->  head  200 OK

  def json_is_signed_user
    @current_user =  current_user
    respond_to do |format|

      if @current_user.nil?
        @is_signed_user = JSON.parse('{"signed":"not"}')

        format.json { render json: @is_signed_user , status: :ok}
      else
        @is_signed_user = JSON.parse('{"signed":"yes"}')
        format.json { render json: @is_signed_user , status: :ok}
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
