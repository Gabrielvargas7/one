class Mywebroom.Views.ProfilePhotosView extends Backbone.View
	className:'user-photos-view'
	template: JST['rooms/profilePhotos']
	render: ->
		$(@el).html(@template(users_photos:@model.get('user_photos')))
		this
