class Mywebroom.Models.UpdateUserNotificationToNotifiedByUserModel extends Backbone.Model
  
  url: ->
    '/users_notifications/json/update_user_notification_to_notified_by_user/' + @id + '.json'
