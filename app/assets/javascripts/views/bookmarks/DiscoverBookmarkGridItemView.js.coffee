class Mywebroom.Views.DiscoverBookmarkGridItemView extends Backbone.View
	#*******************
	#**** Tag  (no tag = default el "div")
	#*******************
	tagName:"li"
	#*******************
	#**** Templeate
	#*******************
	template:JST['bookmarks/DiscoverGridItemTemplate']
	events:
		'click .add_bookmark_icon_hover':'addBookmark'
	#*******************
    #**** Render
    #*******************
	render:->
		$(@el).html(@template(model:@model))
	getUserId:->
		userSignInCollection = new Mywebroom.Collections.ShowSignedUserCollection()
		userSignInCollection.fetch async: false
		userSignInCollection.models[0].get('id')
	getMyBookmarksCollection:(userId)->
		@myBookmarksCollection = new Mywebroom.Collections.IndexUserBookmarksByUserIdAndItemIdCollection()
		@myBookmarksCollection.fetch
		  async:false
		  url:@myBookmarksCollection.url userId, @model.get('item_id')

	addBookmark:(event)->
		event.stopPropagation()
		#To determine position, we need the user id. Get user ID:
		userId = @getUserId() 
		@getMyBookmarksCollection(userId) #Get mybookmarksCollection
		#Finally call api to add the bookmark.
		postBookmarkModel = new Mywebroom.Models.CreateUserBookmarkByUserIdBookmarkIdItemId({itemId:@model.get('item_id'), bookmarkId:@model.get('id'),userId:userId})
		#postBookmarkModel.url()
		postBookmarkModel.set 'position',@myBookmarksCollection.models.length+1
		
		postBookmarkModel.save {},
			success: (model, response)->
				console.log('postBookmarkModel SUCCESS:')
				console.log(response)
			error: (model, response)->
		        console.log('postBookmarkModel FAIL:')
		        console.log(response)


