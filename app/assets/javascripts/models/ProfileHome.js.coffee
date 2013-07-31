class Mywebroom.Models.ProfileHome extends Backbone.Model
  urlRoot: "/rooms/json/show_room_by_user_id/23.json"
  initialize: ->
  	
  	
  parse: (response) ->
  	console.log(response)
  	@user = response.user
  	this.set('email', response.user.email)
  	this.set('username', response.user.username)
  	this.set('user_photos',response.user_photos)
  	@user_profile = response.user_profile	