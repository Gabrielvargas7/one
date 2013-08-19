class Mywebroom.Views.SocialBarView extends Backbone.View
	className:'social_bar'
	template:JST['profile/SocialBar']
	events:
		'click .fb_like_item':'clickFBLikeItem'
		'click .pinterest_item':'clickPinItem'
		'click social_info_bar .info_button_item':'clickInfoBtn'
	render: ->
		$(@el).html(@template(model:@model))
	clickFBLikeItem: (event) ->
		console.log("You clicked FB Like on: "+@model)
	clickPinItem: (event) ->
		console.log("You clicked Pin Item on: " +@model)
	clickInfoBtn: (event) ->
		console.log("You clicked Info Button on " +@model)