class UsersNotificationsController < ApplicationController
  before_filter :signed_in_user,
                only:[
                ]

  before_filter :json_signed_in_user,
                only:[
                    :json_show_user_notification_by_user,
                    :json_update_user_notification_to_notified_by_user


                ]

  before_filter :json_correct_user,
                only:[
                    :json_show_user_notification_by_user,
                    :json_update_user_notification_to_notified_by_user
                ]


  before_filter :correct_user, only:[]
  before_filter :admin_user, only:[]


#***********************************
# Json methods for the room users
#***********************************

# GET get notification by user id
# users_notifications/json/show_user_notification_by_user/:user_id'
# users_notifications/json/show_user_notification_by_user/1.json
#Return ->
#success    ->  head  200 OK
  def json_show_user_notification_by_user


    respond_to do |format|
      if UsersNotification.exists?(user_id: params[:user_id])
        @user_notification = UsersNotification.find_all_by_user_id(params[:user_id]).first

            if Notification.exists?(id:@user_notification.notification_id)

                @notification = Notification.select('notifications.*,users_notifications.notified,users_notifications.user_id').
                                  joins(:users_notifications).where('users_notifications.user_id = ?',params[:user_id])

                format.json { render json: @notification.as_json(only: [:id,:name,:description,:image_name,:position,:notified,:user_id] ) }

            else
              Notification.exists?



              format.json { render json: 'not found notification of user ' , status: :not_found }
            end

      else
        format.json { render json: 'not found user id ' , status: :not_found }
      end
    end

  end


# PUT set user notified to yes by user id
# users_notifications/json/update_user_notification_to_notified_by_user/:user_id'
# users_notifications/json/update_user_notification_to_notified_by_user/1.json'
#Return ->
#success    ->  head  200 OK
def json_update_user_notification_to_notified_by_user


  respond_to do |format|

    if UsersNotification.exists?(user_id: params[:user_id])

      @user_notification = UsersNotification.find_by_user_id(params[:user_id])


      if @user_notification.update_attributes(notified:'y')

        format.json { render json: @user_notification, status: :ok }
      else
        format.json { render json: @user_notification.errors, status: :unprocessable_entity }
      end

    else
      format.json { render json: 'not found user id ' , status: :not_found }
    end
  end

end


end

