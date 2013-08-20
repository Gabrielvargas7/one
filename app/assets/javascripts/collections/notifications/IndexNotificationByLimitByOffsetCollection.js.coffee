class Mywebroom.Collections.IndexNotificationByLimitByOffsetCollection extends Backbone.Collection

  url:(limit,offset) ->
    '/notifications/json/index_notification_by_limit_by_offset/'+limit+'/'+offset+'.json'

