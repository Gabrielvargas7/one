class RoomsController < ApplicationController
  #before_filter :correct_user_by_user_id, only:[:show_room_by_user_id]
  #before_filter :correct_user_by_username, only:[:room]



  def room
        @username = params[:username]
        @user = User.find_by_username(params[:username])

        respond_to do |format|
          format.html # show.html.erb
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
                    select('themes.id,name,description,image_name').
                    joins(:users_themes).
                    where('user_id = ?',@user.id)
                @user_items_designs = ItemsDesign.
                    select('items_designs.id ,name,item_id,description,image_name,users_items_designs.hide').
                    joins(:users_items_designs).
                    where('user_id = ?',@user.id)

                  format.json { render json: {
                      user: @user,
                                              user_gallery: @user_gallery,
                                              user_theme: @user_theme,
                                              user_items_designs: @user_items_designs.as_json(include: {item: {only: [:name, :id, :x, :y, :z, :clickable, :height, :width]}})

                  }}
          else
            format.json { render json: 'not found user id' , status: :not_found }
          end

      end

  end

  private

  def correct_user_by_username
    @user = User.find_by_username(params[:username])
    redirect_to(root_path) unless current_user?(@user)
  end


  def correct_user_by_user_id
    @user = User.find(params[:user_id])
    head :bad_request unless current_user?(@user)
  end






end