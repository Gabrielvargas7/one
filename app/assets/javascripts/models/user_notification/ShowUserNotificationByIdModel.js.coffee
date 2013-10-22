class Mywebroom.Models.ShowUserNotificationByIdModel extends Backbone.Model

  url: ->
    'users_notifications/json/show_user_notification_by_user/' + @id + '.json'
