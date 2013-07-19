class RoomsController < ApplicationController

  #method for Json access
  before_filter :json_signed_in_user,
                only:[
                    :json_show_room_by_user_id
                ]
  before_filter :json_correct_user,
                only:[
                    :json_show_room_by_user_id
                ]
  #method for ruby access
  before_filter :signed_in_user,
                only:[
                    :room
                ]

  before_filter :correct_username,
                only:[
                    :room
                    ]





  # GET Get room with the username
  # /room/:username
  # room_rooms_path // room_rooms_url
  # public
  def room

    if User.exists?(username:params[:username])

        @username = params[:username]

        @user = User.find_by_username(params[:username])
        @user_theme = UsersTheme.find_by_user_id(@user.id)

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


  # GET Get all the user's items design,themes
    # /rooms/json/show_room_by_user_id/:user_id
  # /rooms/json/show_room_by_user_id/1.json
  # Return head
  # success    ->  head  200 OK

  def json_show_room_by_user_id

      respond_to do |format|

          #validate if the user exist
          if User.exists?(id:params[:user_id])

                @user = User.select('id ,email,username').where('id = ?',params[:user_id]).first
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

                            users_items_designs.hide,
                            users_items_designs.location_id,

                            locations.z,
                            locations.x,
                            locations.y,
                            locations.height,
                            locations.width,
                            locations.section_id,

                            items.name as items_name,
                            sections.name as section_name'
                            ).
                    joins(:users_items_designs).
                    where('user_id = ?',@user.id).
                    joins('LEFT OUTER JOIN locations  ON locations.id = users_items_designs.location_id').
                    joins('LEFT OUTER JOIN items  ON items.id = items_designs.item_id').
                    joins('LEFT OUTER JOIN sections ON sections.id = locations.section_id')



                  format.json { render json: {
                                              user: @user,
                                              user_photos: @user_photos,
                                              user_profile:@user_profile,
                                              user_theme: @user_theme,
                                              user_items_designs: @user_items_designs

                  }}
          else
            format.json { render json: 'not found user id' , status: :not_found }
          end

      end

  end




end
