class Mywebroom.Views.ProfileKeyRequestSingleView extends Backbone.View
	template:JST['profile/ProfileRequestSingleTemplate']
	tagName:'tr'
	className:'profile_single_request'
	render: ->
		$(@el).html(@template(model:@model))