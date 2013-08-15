class Mywebroom.Views.ProfileFriendsSuggestionSingleView extends Backbone.View
	tagName:'tr'
	template: JST['profile/ProfileFriendsSuggestionSingle']
	render: ->
		$(@el).html(@template(model:@model))
