class Mywebroom.Views.ProfileBookmarksView extends Backbone.View
	template:JST['profile/ProfileBookmarksTemplate']
	initialize: ->
		@bookmarksCollection = new Mywebroom.Collections.IndexUserBookmarksByUserIdCollection()
		@bookmarksCollection.fetch
			url:@bookmarksCollection.url @model.get('user_id')
			async:false
			success: (response)->
				console.log("UsersBookmarks fetched success:")
				console.log(response)
		@bookmarksGridView = new Mywebroom.Views.ProfileTableOuterDivView(collection:@collection,model:@model)
		#if(@model.FLAG_PROFILE is Mywebroom.Views.RoomView.PUBLIC_ROOM)
		@bookmarksCollection = @bookmarksCollection.first 9
	render:->
		$(@el).html(@template(model:@model))
		$(@el).append(JST['profile/ProfileGridTableHeader'](headerName:"Bookmarks"))
		$(@el).append(@bookmarksGridView.render().el)
		#overlay test
		#if(@model.FLAG_PROFILE is Mywebroom.Views.RoomView.PUBLIC_ROOM)
		$(@el).append(JST['profile/ProfileAskForKey']())
		this
	