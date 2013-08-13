class Mywebroom.Views.ProfileFriendsView extends Backbone.View
	className:profileFriends
	template: JST['profile/ProfileFriends']
	render: ->
		$(@el).html(@template(model:@model))
