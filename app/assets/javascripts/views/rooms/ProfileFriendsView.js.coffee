class Mywebroom.Views.ProfileFriendsView extends Backbone.View
	className:'profile_friend media'
	template: JST['profile/ProfileFriends']
	render: ->
		$(@el).html(@template(model:@model))
