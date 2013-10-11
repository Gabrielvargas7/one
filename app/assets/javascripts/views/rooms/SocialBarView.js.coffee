class Mywebroom.Views.SocialBarView extends Backbone.View
	className:'social_bar'
	template:JST['profile/SocialBarTemplate']
	events:
		'click .fb_like_item':'clickFBLikeItem'
		'click .pinterest_item':'pinIt'
		'click social_info_bar .info_button_item':'clickInfoBtn'
	
	render: ->
		fbUrl = encodeURIComponent(@generateFacebookURL())
		$(@el).html(@template(model:@model, fbUrl:fbUrl))
		#apply the FB script to this element.
		#FB.XFBML.parse($(@el)[0])
	
	hide:->
		$(@el).hide()
	show:->
		$(@el).show()
	clickFBLikeItem: (event) ->
		console.log("You clicked FB Like on: "+@model)
	
	clickPinItem: (event) ->
		console.log("You clicked Pin Item on: " +@model)
	
	clickInfoBtn: (event) ->
		console.log("You clicked Info Button on " +@model)
	
	generateFacebookURL:->
		if @model.get('image_name_selection')
			return  Mywebroom.State.get('shopBaseUrl').itemDesign + @model.get('id')
		else if @model.get('image_name_desc')
			return  Mywebroom.State.get('shopBaseUrl').bookmark
		else
			return Mywebroom.State.get('shopBaseUrl').default

	pinIt:(event)->
		event.preventDefault()
		event.stopPropagation()
		pinterestURL= @generatePinterestUrl()
		if pinterestURL
			window.open(pinterestURL,'_blank','width=750,height=350,toolbar=0,location=0,directories=0,status=0');
	
	generatePinterestUrl:->
		baseUrl = '//pinterest.com/pin/create/button/?url='
		targetUrl = @model.get('product_url')
		targetUrl = "http://mywebroom.com" if !targetUrl
		if @model.get('image_name_selection')
			#This is an items-design
			mediaUrl = @model.get('image_name_selection').url
			targetUrl = Mywebroom.State.get('shopBaseUrl').itemDesign + @model.get('id')
			description = @model.get('name') + ' - '
		else if @model.get('image_name_desc')
			#this is a bookmark
			mediaUrl = @model.get('image_name_desc').url
			targetUrl = Mywebroom.State.get('shopBaseUrl').bookmark
			description = @model.get('title') + ' - '
		else
			#IDK what this is
			mediaUrl = @model.get('image_name').url
			targetUrl = Mywebroom.State.get('shopBaseUrl').default
		if !targetUrl or !mediaUrl
			#something is wrong and we can't pin. 
			console.log "Error with Pinterest Parameters."
			return false
		description += @model.get('description')+ ' - Found at http://myWebRoom.com'
		pinterestUrl = baseUrl + encodeURIComponent(targetUrl) +
						'&media=' + encodeURIComponent(mediaUrl) +
						'&description=' + encodeURIComponent(description)