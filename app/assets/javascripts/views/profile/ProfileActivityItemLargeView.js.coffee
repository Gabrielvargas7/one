class Mywebroom.Views.ActivityItemLargeView extends Backbone.View
	template: JST['profile/ProfileActivityItemLargeTemplate']
	className: 'activity_item_large_wrap'
	initialize: ->
		 _.bindAll this, 'insideHandler', 'outsideHandler'
		 @originalCollection=this.options.originalCollection
		 $('body').on('click', this.outsideHandler);
		 #$('div').not('.activity_item_large_wrap *').on('click', this.outsideHandler);
		 if @model.collection.constructor.name is Mywebroom.Collections.IndexUsersPhotosByUserIdByLimitByOffsetCollection.name
  			@template = JST['profile/ProfilePhotosLargeTemplate']
  		@fbUrl = @generateFacebookURL()
	events:
		'click #large_item_prev':'showNext'
		'click #large_item_next':'showNext'
		'click .profile_large_item_try_it_button':'showStore'
		'click .gridItem':'closeView'
		'click .pinterest_item':'pinIt'
	
	render: ->
		$("#profile_drawer").css "width", "1320px" 
		$(@el).html(@template(model:@model,fbUrl:@fbUrl))
		FB.XFBML.parse($(@el)[0])
		#The social View is in the template because
		#the styling was not right with this view. It needs a parent wrapper div, and the 
		#social view cannot append elegantly with the current styling.
		#Revisit if we use a Backbone Layout Plugin like SubViews or Marionette.
		this
	
	insideHandler: (event) ->
		event.stopPropagation()
		console.log "insideHandler called"
	
	outsideHandler: (event) ->
		console.log "outsideHandler called"
		console.log(event)
		#If event src element is try in my room, close this view and open store.
		#if event src is next or prev, change model to next in collection.
		#else close view
		@closeView()
		return false
	
	closeView: ->
		$('body').off('click', this.outsideHandler);
		#change profile_drawer widths back to original
		$("#profile_drawer").css "width", "760px"
		this.$el.remove()
		console.log "ActivityItemLargeView closed"
		this
	
	showNext:(event) ->
		event.stopPropagation()
		this.trigger('ProfileActivityLargeView:showNext',event,@model)
	
	showStore:(event)->
		event.stopPropagation()
		#if item is object, show store. 
		#if item is bookmark add bookmark.
		if @model.get('bookmark_url')
			console.log 'this is a bookmark. add it to your collection!'
			console.log @model
			#get userID, Item ID, BookmarkID
			helper = new Mywebroom.Helpers.ItemHelper()
			userId= helper.getUserId()
			#Post bookmark
			position = @getMyBookmarksLength(userId)
			#CHeck if bookmark is here already:
			if !@myBookmarksCollection.get(@model.id)
				postBookmarkModel = new Mywebroom.Models.CreateUserBookmarkByUserIdBookmarkIdItemId({itemId:@model.get('item_id'), bookmarkId:@model.get('id'),userId:userId})
				postBookmarkModel.set 'position',position+1
				postBookmarkModel.save {},
					success: (model, response)->
						console.log('postBookmarkModel SUCCESS:')
						console.log(response)
					error: (model, response)->
				        console.log('postBookmarkModel FAIL:')
				        console.log(response)
			#Added confirmation.
			@$('.activity_item_large_view_img_wrap').append("<div class='large_item_just_added'>
			<p>Added!</p>
			<img src='http://res.cloudinary.com/hpdnx5ayv/image/upload/v1378226370/bookmarks-corner-icon-check-confirmation.png'>
			</div>")
		else
			console.log 'hide ya profile cause the store\'s comin out y\'all'
			console.log @model
			#hide Profile , Show Store
			$('#xroom_storepage').show()
			$('#xroom_profile').hide()
			# (trigger store event?)
			#Should show item in store view with object centered. 
			#This model only has bundle_id, and id. No item_id or Item Design Name. 
			@closeView()
	
	getMyBookmarksLength:(userId)->
		@myBookmarksCollection = new Mywebroom.Collections.IndexUserBookmarksByUserIdAndItemIdCollection()
		@myBookmarksCollection.fetch
		  async:false
		  url:@myBookmarksCollection.url userId, @model.get('item_id')
		parseInt(_.last(@myBookmarksCollection.models).get('position'))
	
	pinIt:(event)->
		event.preventDefault()
		event.stopPropagation()
		pinterestURL= @generatePinterestUrl()
		if pinterestURL
			window.open(pinterestURL,'_blank','width=750,height=350,toolbar=0,location=0,directories=0,status=0');
	
	generatePinterestUrl:->
		baseUrl = '//pinterest.com/pin/create/button/?url='
		@targetUrl = @model.get('product_url')
		@targetUrl = "http://mywebroom.com" if !@targetUrl
		if @model.get('image_name_selection')
			#This is an items-design
			mediaUrl = @model.get('image_name_selection').url
			@targetUrl = Mywebroom.State.get('shopBaseUrl').itemDesign + @model.get('id')
			description = @model.get('name') + ' - '
			signature = ' - Found at myWebRoom.com'
		else if @model.get('image_name_desc')
			#this is a bookmark
			mediaUrl = @model.get('image_name_desc').url
			@targetUrl = Mywebroom.State.get('shopBaseUrl').bookmark
			description = @model.get('title') + ' - '
			signature = ' - For my virtual room at myWebRoom.com'
		else
			#IDK what this is
			mediaUrl = @model.get('image_name').url
			@targetUrl = Mywebroom.State.get('shopBaseUrl').default
			signature = ' - Found at myWebRoom.com'
		if !@targetUrl or !mediaUrl
			#something is wrong and we can't pin. 
			console.log "Error with Pinterest Parameters."
			return false
		description += @model.get('description')+ signature
		pinterestUrl = baseUrl + encodeURIComponent(@targetUrl) +
						'&media=' + encodeURIComponent(mediaUrl) +
						'&description=' + encodeURIComponent(description)
	generateFacebookURL:->
		if @model.get('image_name_selection')
			return  Mywebroom.State.get('shopBaseUrl').itemDesign + @model.get('id')
		else if @model.get('image_name_desc')
			return  Mywebroom.State.get('shopBaseUrl').bookmark
		else
			return Mywebroom.State.get('shopBaseUrl').default
	
