class RoomsController < ApplicationController


  #method for Json access
  before_filter :json_signed_in_user,
                only:[

                ]
  before_filter :json_correct_user,
                only:[

                ]
  #method for ruby access
  before_filter :signed_in_user,
                only:[

                ]

  before_filter :correct_username,
                only:[

                    ]




  # GET Get room with the username
  # /xroom
  # xroom_rooms_path // xroom_rooms_url
  # public
  def xroom

    # when is not filter( it should get first
    if params[:bundle_id].blank?
      @bundle = Bundle.where("active = 'y'").order(:id).first
    else

      if params[:moving_toward] =='next'
        #@bundle = Bundle.find(params[:bundle_id])
        if Bundle.where("active = 'y' and id > ?", params[:bundle_id]).exists?
            @bundle = Bundle.where("active = 'y' and id > ?", params[:bundle_id]).order(:id).first

        else
          @bundle = Bundle.where("active = 'y'").order(:id).first
        end
      else

        if Bundle.where("active = 'y' and id < ?", params[:bundle_id]).exists?
          @bundle = Bundle.where("active = 'y' and id < ?", params[:bundle_id]).order(:id).last
        else
          @bundle = Bundle.where("active = 'y'").order(:id).last
        end
      end
    end

    # add cookies for facebook signup
    cookies.permanent[:facebook_bundle_id] = @bundle.id


    #@static_content_logo = StaticContent.find_by_name("mywebroom-logo")

    if StaticContent.exists?(name:"arrows")
        @static_content_arrows = StaticContent.find_by_name("arrows")
        @arrows_image = @static_content_arrows.image_name
    else
        @arrows_image = ''
    end

    if StaticContent.exists?(name:"mywebroom-logo")
      @static_content_logo = StaticContent.find_by_name("mywebroom-logo")
    else
    end







    @skip_header = true
    @skip_container = true
    @skip_footer = true
    @room_backgroud_color = true


    respond_to do |format|
        format.html
    end

  end


  # GET Get room with the username
  # /room/:username
  # room_rooms_path // room_rooms_url
  # public

  # This method gets called when a user is signed in and navigates to root,
  # or when a user (signed in or not) navigates to room/<name>
  def room

    if User.exists?(username:params[:username])

        # We set a few variables for the room - the user's name, a user object, and the user's theme.
        # We ought to use them.
        @username = params[:username]
        @user = User.find_by_username(params[:username])
        @user_theme = UsersTheme.find_by_user_id(@user.id)


        # Here we set a cookie
        set_room_user @user

        # Note: we also have access to a function that checks to see if the room user is the same as the user

        # SET STATIC CONTENTS
        @static_contents = StaticContent.all



        @skip_header = true
        @skip_container = true
        @skip_footer = true
        @room_backgroud_color = true



        respond_to do |format|
          format.html
          format.json { render json:@user.as_json(only: [:id,:name, :username, :image_name ])  }
        end
    else
      redirect_to(root_path)
    end
  end




  #***********************************
  # Json methods for the room users
  #***********************************

  # GET get user the is visit
  #  /rooms/json/show_room_user
  #  /rooms/json/show_room_user
  #  /# success    ->  head  200 OK

  def json_show_room_user

    @room_user = room_user
    respond_to do |format|
      if @room_user.nil?
        format.json { render json: 'user not found' , status: :not_found }
      else
        format.json { render json: @room_user.as_json(only:[:id,:username]), status: :ok}
      end


    end
  end



  # GET Get all the user's items design,themes
    # /rooms/json/show_room_by_user_id/:user_id
  # /rooms/json/show_room_by_user_id/1.json
  # Return head
  # success    ->  head  200 OK

  def json_show_room_by_user_id

      respond_to do |format|

          #validate if the user exist
          if User.exists?(id:params[:user_id])

                @user = User.select('id,username').where('id = ?',params[:user_id]).first
                @profile_image = 'y'
                @user_photos = UsersPhoto.find_all_by_user_id_and_profile_image(@user.id,@profile_image).first
                @user_profile = UsersProfile.find_all_by_user_id(@user.id).first
                @user_theme = Theme.
                    select('themes.id,
                            themes.name,
                            themes.description,
                            themes.image_name,
                            themes.category,
                            themes.style,
                            themes.brand,
                            themes.location,
                            themes.color,
                            themes.make,
                            themes.special_name,
                            themes.like,
                            users_themes.section_id,
                            sections.name as section_name').
                    joins(:users_themes).
                    where('user_id = ?',@user.id).
                    joins('LEFT OUTER JOIN sections ON sections.id = users_themes.section_id')

                @user_items_designs = ItemsDesign.
                    select('items_designs.id ,
                            items_designs.name,
                            items_designs.item_id,
                            items_designs.description,
                            items_designs.category,
                            items_designs.style,
                            items_designs.brand,
                            items_designs.color,
                            items_designs.make,
                            items_designs.special_name,
                            items_designs.like,
                            items_designs.image_name,
                            items_designs.image_name_hover,
                            items_designs.image_name_selection,

                            users_items_designs.hide,
                            users_items_designs.location_id,

                            locations.z,
                            locations.x,
                            locations.y,
                            locations.height,
                            locations.width,
                            locations.section_id,

                            items.name as items_name,
                            items.name_singular as items_name_singular,

                            items.clickable,
                            sections.name as section_name'
                            ).
                    joins(:users_items_designs).
                    where('user_id = ?',@user.id).
                    joins('LEFT OUTER JOIN locations  ON locations.id = users_items_designs.location_id').
                    joins('LEFT OUTER JOIN items  ON items.id = items_designs.item_id').
                    joins('LEFT OUTER JOIN sections ON sections.id = locations.section_id')


                @user_items = Item.
                    select('
                            users_items_designs.items_design_id,
                            users_items_designs.hide,
                            users_items_designs.location_id,
                            users_items_designs.first_time_click,
                            users_items_designs.user_id,

                            items.id as item_id,
                            items.name,
                            items.name_singular,

                            items.image_name_first_time_click,
                            items.image_name,
                            items.image_name_gray').
                    joins(:items_designs).
                    joins('inner join users_items_designs ON users_items_designs.items_design_id= items_designs.id').
                    where('users_items_designs.user_id = ?',@user.id)







                format.json { render json: {
                                              user: @user,
                                              user_photos: @user_photos,
                                              user_profile:@user_profile,
                                              user_theme: @user_theme,
                                              user_items_designs: @user_items_designs,
                                              user_items: @user_items

                  }}
          else
            format.json { render json: 'not found user id' , status: :not_found }
          end
      end

  end


  # Get random items and bookmarks of all items or bookmarks
  # GET 'rooms/json/index_random_items_bookmarks_by_limit_by_offset/:limit/:offset.json'
  #  # GET 'rooms/json/index_notification_by_limit_by_offset/5/0.json'
  #Return head 200 OK
  def json_index_notification_by_limit_by_offset
    @notifications = Notification.order("updated_at desc").limit(params[:limit]).offset(params[:offset])
    respond_to do |format|
      format.json { render json: @notifications }
    end
  end






end
