class Mywebroom.Models.UpdateUserNotificationToNotifiedByUserModel extends Backbone.Model

  @user_id
  idAttribute: "_id"
  
  url: ->
    '/users_notifications/json/update_user_notification_to_notified_by_user/' + @user_id + '.json'
