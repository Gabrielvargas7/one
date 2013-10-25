class Mywebroom.Collections.ShowUserNotificationByUserCollection extends Backbone.Collection
  
  initialize: (models, options) ->
    this.user_id = options.user_id
  
  
  url: ->
    '/users_notifications/json/show_user_notification_by_user/' + this.user_id + '.json'


  parse: (response) ->
    _.map(response, (model) ->
      obj = model
      obj.type = "NOTIFICATION"
      return obj
    )
