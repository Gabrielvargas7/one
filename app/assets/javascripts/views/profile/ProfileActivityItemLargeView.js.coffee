class Mywebroom.Views.ActivityItemLargeView extends Backbone.View
	template: JST['profile/ProfileActivityItemLargeTemplate']
	className: 'activity_item_large_wrap'
	initialize: ->
		 _.bindAll this, 'insideHandler', 'outsideHandler'
	events:
		'click .large_item_nav_arrow.flipimg':'showPrev'
		'click .large_item_nav_arrow':'showNext'
		'click .profile_large_item_try_it_button':'showStore'
	render: ->
		$('body').on('click', this.outsideHandler);
		$(@el).html(@template(model:@model))
		#The social View is in the template because
		#the styling was not right with this view. It needs a parent wrapper div, and the 
		#social view cannot append elegantly with the current styling.
		#Revisit if we use a Backbone Layout Plugin like SubViews or Marionette.
		# #append social view to el here
		# socialBarView = new Mywebroom.Views.SocialBarView({model:@model})
		# $(@el).append(socialBarView.el)
		# socialBarView.render()

		
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
	showNext: ->
		event.stopPropagation()
		currentModelIndex = @collection.getIndexOf(@model)
		newModel = @collection.at(currentModelIndex+1);
		console.log newModel
		console.log "someday I'll show next"
	showPrev:->
		console.log "someday I'll show prev"
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
			@$('.activity_item_img_wrap').append("<div class='large_item_just_added'>
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

