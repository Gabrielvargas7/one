class Mywebroom.Collections.RoomObjectsCollection extends Backbone.Collection
  model: Mywebroom.Models.RoomObject
  url: "/rooms/json/show_room_by_user_id/23.json"
  parse: (response) ->
  	console.log(response)
  	@user = response.user
  	@user_profile = response.user_profile
  	response.user_items_designs