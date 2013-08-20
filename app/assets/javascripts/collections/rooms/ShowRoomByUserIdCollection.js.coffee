class Mywebroom.Collections.ShowRoomByUserIdCollection extends Backbone.Collection

  url:(userId) ->
    '/rooms/json/show_room_by_user_id/'+userId+'.json'