class UsersThemesController < ApplicationController
  #before_filter :correct_user_by_user_id, only:[:update_user_theme_by_user_id]




  def update_user_theme_by_user_id

    #validate themes
    if Theme.exists?(params[:theme_id])

      @user_theme = UsersTheme.find_by_user_id(params[:user_id])

      respond_to do |format|
        if @user_theme.update_attributes(theme_id: params[:theme_id])
          format.json { head :no_content }
        else
          format.json { render json: @user_theme.errors, status: :unprocessable_entity }
        end
      end
    else

      head :bad_request

    end
  end


private
  def correct_user_by_user_id
    @user = User.find(params[:user_id])

     head :bad_request unless current_user?(@user)
  end



end
