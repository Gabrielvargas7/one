class RoomsController < ApplicationController

  before_filter :json_signed_in_user,
                only:[
                    :json_show_room_by_user_id

                ]

  before_filter :json_correct_user,
                only:[
                    :json_show_room_by_user_id
                ]


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
  def room
        @username = params[:username]
        @user = User.find_by_username(params[:username])

        respond_to do |format|
          format.html
          format.json { render json:@user.as_json(only: [:id,:name, :username, :image_name ])  }

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

                @user = User.select('id , name,email,image_name').where('id = ?',params[:user_id]).first

                @user_theme = Theme.
                    select('themes.id,themes.name,themes.description,image_name,users_themes.section_id, sections.name as section_name').
                    joins(:users_themes).
                    where('user_id = ?',@user.id).
                    joins('LEFT OUTER JOIN sections ON sections.id = users_themes.section_id')

                @user_items_designs = ItemsDesign.
                    select('items_designs.id ,
                            items_designs.name,
                            items_designs.item_id,
                            items_designs.description,
                            image_name,
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
                                              user_gallery: @user_gallery,
                                              user_theme: @user_theme,
                                              user_items_designs: @user_items_designs.as_json()

                  }}
          else
            format.json { render json: 'not found user id' , status: :not_found }
          end

      end

  end




end
