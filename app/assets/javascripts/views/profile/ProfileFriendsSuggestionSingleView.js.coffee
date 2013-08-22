class Mywebroom.Views.ProfileFriendsSuggestionSingleView extends Backbone.View
	tagName:'tr'
	className:'profile_friends_suggestion_single'
	template: JST['profile/ProfileFriendsSuggestionSingleTemplate']
	render: ->
		$(@el).html(@template(model:@model))
