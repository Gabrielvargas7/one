class Mywebroom.Views.ProfilePhotosView extends Backbone.View
	className:'user-photos-view'
	template: JST['profile/profileHomeGrid']
	render: ->
		$(@el).html(@template(activity:@collection))
		this
