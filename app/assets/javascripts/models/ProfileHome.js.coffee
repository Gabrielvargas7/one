class Mywebroom.Models.ProfileHome extends Backbone.Model
  #urlRoot: "/rooms/json/show_room_by_user_id/23.json"
  initialize: ->
  	#Fetch Activity INS data
    #Collection named index_notification_by_limit_by_offset
    #Model named ProfileActivityModel
    #View named ProfileActivityView
#    @activityModel = new Mywebroom.Models.ProfileActivity({})

  parse: (response) ->
  	console.log(response)
  	@user = response.user
  	this.set('email', response.user.email)
  	this.set('username', response.user.username)
  	this.set('user_photos',response.user_photos)
  	@user_profile = response.user_profile	