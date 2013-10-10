class Mywebroom.Views.SocialBarView extends Backbone.View
	className:'social_bar'
	template:JST['profile/SocialBarTemplate']
	events:
		'click .fb_like_item':'clickFBLikeItem'
		'click .pinterest_item':'pinIt'
		'click social_info_bar .info_button_item':'clickInfoBtn'
	render: ->
		$(@el).html(@template(model:@model))
	clickFBLikeItem: (event) ->
		console.log("You clicked FB Like on: "+@model)
	clickPinItem: (event) ->
		console.log("You clicked Pin Item on: " +@model)
	clickInfoBtn: (event) ->
		console.log("You clicked Info Button on " +@model)
	pinIt:(event)->
		event.preventDefault()
		event.stopPropagation()
		pinterestURL= @generatePinterestUrl()
		window.open(pinterestURL,'_blank','width=750,height=350,toolbar=0,location=0,directories=0,status=0');
	
	generatePinterestUrl:->
		baseUrl = '//pinterest.com/pin/create/button/?url='
		targetUrl = @model.get('product_url')
		targetUrl = "http://mywebroom.com" if targetUrl is null
		mediaUrl = @model.get('image_name').url
		if @model.get('image_name_selection')
			mediaUrl = @model.get('image_name_selection').url
		else
			mediaUrl = @model.get('image_name').url
		description = @model.get('description')+ ' See more Rooms, Inc at http://mywebroom.com'
		pinterestUrl = baseUrl + encodeURIComponent(targetUrl) +
						'&media=' + encodeURIComponent(mediaUrl) +
						'&description=' + encodeURIComponent(description)