class Mywebroom.Collections.ShowRoomByUserIdCollection extends Backbone.Collection

  url: (userId) ->
    '/rooms/json/show_room_by_user_id/'+userId+'.json'

#  url: (userID,limit,offset) ->
#  '/friends/json/index_friend_by_user_id_by_limit_by_offset/'+userID+'/'+limit+'/'+offset+'.json'
#
#  url: ->
#    '/rooms/json/show_room_by_user_id/'+@user_id+'.json'