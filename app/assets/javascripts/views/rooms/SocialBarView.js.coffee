class Mywebroom.Views.SocialBarView extends Backbone.View
	className:'social_bar'
	template:JST['profile/SocialBar']
	render: ->
		$(@el).html(@template(model:@model))