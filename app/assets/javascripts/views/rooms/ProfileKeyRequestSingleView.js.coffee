class Mywebroom.Views.ProfileKeyRequestSingleView extends Backbone.View
	template:JST['profile/ProfileRequestSingle']
	className:'profile_single_request'
	render: ->
		$(@el).html(@template(model:@model))