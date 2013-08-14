class Mywebroom.Views.ProfileKeyRequestSingleView
	template:JST['profile/ProfileRequestSingle']
	className:'profile_single_request'
	render: ->
		$(@el).html(@template(model:@model))