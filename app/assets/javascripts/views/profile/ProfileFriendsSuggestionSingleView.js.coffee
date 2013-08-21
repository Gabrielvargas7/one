class Mywebroom.Views.ProfileFriendsSuggestionSingleView extends Backbone.View
	tagName:'tr'
	template: JST['profile/ProfileFriendsSuggestionSingleTemplate']
	render: ->
		$(@el).html(@template(model:@model))
