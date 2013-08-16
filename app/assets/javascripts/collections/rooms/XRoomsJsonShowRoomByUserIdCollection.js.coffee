class Mywebroom.Collections.XRoomsJsonShowRoomByUserIdCollection extends Backbone.Collection

  @user_id

  url: ->
    '/rooms/json/show_room_by_user_id/'+@user_id+'.json'