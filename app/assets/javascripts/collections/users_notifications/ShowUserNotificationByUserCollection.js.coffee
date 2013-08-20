class Mywebroom.Collections.ShowUserNotificationByUserCollection extends Backbone.Collection

  url:(userId) ->
    '/users_notifications/json/show_user_notification_by_user/'+userId+'.json'


