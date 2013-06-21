class UsersThemesController < ApplicationController

  before_filter :signed_in_user,
                only:[
                ]

  before_filter :json_signed_in_user,
                only:[
                    :json_show_user_theme_by_user_id_and_section_id,
                    :json_update_user_theme_by_user_id_and_section_id


                ]

  before_filter :json_correct_user,
                only:[
                    :json_show_user_theme_by_user_id_and_section_id,
                    :json_update_user_theme_by_user_id_and_section_id,

  ]


  before_filter :correct_user, only:[]
  before_filter :admin_user, only:[]




  #***********************************
  # Json methods for the room users
  #***********************************

  # GET get theme by user id
  # users_themes/json/show_user_theme_by_user_id_and_section_id/:user_id/:section_id'
  # users_themes/json/show_user_theme_by_user_id_and_section_id/1/1.json
  #Return ->
  #success    ->  head  200 OK
  def json_show_user_theme_by_user_id_and_section_id



    respond_to do |format|

      if UsersTheme.exists?(user_id: params[:user_id],section_id:params[:section_id])


        @user_theme = UsersTheme.find_by_user_id_and_section_id(params[:user_id],params[:section_id])

        if Theme.exists?(id:@user_theme.theme_id)

          @theme = Theme.find(@user_theme.theme_id)
          format.json { render json: @theme.as_json(only: [:id,:name,:description,:image_name]) }
        else
          format.json { render json: 'not found theme of user ' , status: :not_found }
        end
      else
        format.json { render json: 'not found user id ' , status: :not_found }
      end
    end
  end



  # PUT change the user's theme by user id
  #  users_themes/json/update_user_theme_by_user_id_and_section_id/:user_id/:section_id'
  #  users_themes/json/update_user_theme_by_user_id_and_section_id/1/1.json
  #  Form Parameters:
  #                  theme_id = 1
  # Return ->
  # Success    ->  head  200 ok
  def json_update_user_theme_by_user_id_and_section_id

    respond_to do |format|

      if User.exists?(id:params[:user_id])
        #validate themes
        if Theme.exists?(id: params[:theme_id])

          if UsersTheme.exists?(user_id:params[:user_id],section_id:params[:section_id])

              @user_theme = UsersTheme.find_by_user_id_and_section_id(params[:user_id],params[:section_id])

              if @user_theme.update_attributes(theme_id: params[:theme_id],section_id:params[:section_id])

                format.json { render json: @user_theme, status: :ok }

              else
                format.json { render json: @user_theme.errors, status: :unprocessable_entity }
              end
          else
            format.json { render json: 'not found user on the usertheme table ' , status: :not_found }
          end
        else
          format.json { render json: 'not found theme ' , status: :not_found }
        end
      else
        format.json { render json: 'not found user_id ' , status: :not_found }
      end
    end
  end


end
