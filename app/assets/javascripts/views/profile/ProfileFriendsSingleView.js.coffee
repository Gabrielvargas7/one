class Mywebroom.Views.ProfileFriendsSingleView extends Backbone.View
	className:'profile_friend media'
	template: JST['profile/ProfileFriendsTemplate']
	render: ->
		$(@el).html(@template(model:@model,PUBLIC_FLAG:this.options.PUBLIC_FLAG))