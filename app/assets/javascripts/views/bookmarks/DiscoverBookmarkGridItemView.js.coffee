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
	addBookmark:(event)->
		event.stopPropagation()
		console.log "ADD BOOKMARKS PLZ"
		postBookmarkModel = new Mywebroom.Models.CreateUserBookmarkByUserIdBookmarkIdItemId({itemId:@model.get('item_id'), bookmarkId:@model.get('id'),userId:24})
		postBookmarkModel.itemId=@model.get('item_id')
		postBookmarkModel.bookmarkId=@model.get('id')
		postBookmarkModel.userId=24
		#save doesn't detect any changes from when we identified the model? but still, the url is not updated.why not? :(
		#Trying to get POST to work. Trying to add a bookmark to database. success and error functions are not working.  
		

		#postBookmarkModel.set 'bookmarkId', @model.get('bookmarkId')
		#postBookmarkModel.set('url', postBookmarkModel.url(24,@model.get('id'),@model.get('item_id')))
		postBookmarkModel.save
			success: (model, response)->
				console.log('SUCCESS:')
				console.log(response)
			error: (model, response)->
		        console.log('FAIL:')
		        console.log(response)


