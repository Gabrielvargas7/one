class UsersThemesController < ApplicationController
  #before_filter :correct_user_by_user_id, only:[:update_user_theme_by_user_id]




  #***********************************
  # Json methods for the room users
  #***********************************

  # GET get theme by user id
  # users_themes/json/show_user_theme_by_user_id/:user_id'
  # users_themes/json/show_user_theme_by_user_id/1.json

  def json_show_user_theme_by_user_id



    respond_to do |format|

      if UsersTheme.exists?(user_id: params[:user_id])


        @user_theme = UsersTheme.find_by_user_id(params[:user_id])

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
  #  users_themes/json/update_user_theme_by_user_id/:user_id'
  #  users_themes/json/update_user_theme_by_user_id/1.json
  #  Form Parameters:
  #                  theme_id = 1


  def json_update_user_theme_by_user_id

    respond_to do |format|

      if User.exists?(id:params[:user_id])
        #validate themes
        if Theme.exists?(id: params[:theme_id])

          if UsersTheme.exists?(user_id:params[:user_id])

              @user_theme = UsersTheme.find_by_user_id(params[:user_id])

              if @user_theme.update_attributes(theme_id: params[:theme_id])
                format.json { head :no_content }
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


private
  def correct_user_by_user_id
    @user = User.find(params[:user_id])

     head :bad_request unless current_user?(@user)
  end



end
