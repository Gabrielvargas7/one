#theme_collection in rooms_index uses this collection.
class Mywebroom.Collections.RoomsJsonShowRoomByUserId extends Backbone.Collection
  #default url. This is overriden by the user id when this collection is fetched. 
  #url: "/rooms/json/show_room_by_user_id/23.json"
  model: Mywebroom.Models.RoomTheme
