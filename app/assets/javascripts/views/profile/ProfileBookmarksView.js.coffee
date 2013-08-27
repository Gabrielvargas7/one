class Mywebroom.Views.ProfileBookmarksView extends Backbone.View
	template:JST['profile/ProfileBookmarksTemplate']
	events:
		'click #profile_ask_for_key_overlay button':'askForKey'
	initialize: ->
		@bookmarksCollection = new Mywebroom.Collections.IndexUserBookmarksByUserIdCollection()
		@bookmarksCollection.fetch
			url:@bookmarksCollection.url @model.get('user_id')
			async:false
			success: (response)->
				console.log("UsersBookmarks fetched success:")
				console.log(response)	
		#if(@model.FLAG_PROFILE is Mywebroom.Views.RoomView.PUBLIC_ROOM)
		@bookmarksCollection.reset(@bookmarksCollection.first(9), silent:true)
		@bookmarksGridView = new Mywebroom.Views.ProfileTableOuterDivView(collection:@bookmarksCollection,model:@model)
	render:->
		$(@el).html(@template(model:@model))
		$(@el).append(JST['profile/ProfileGridTableHeader'](headerName:"Bookmarks"))
		$(@el).append(@bookmarksGridView.render().el)
		#overlay test
		#if(@model.FLAG_PROFILE is Mywebroom.Views.RoomView.PUBLIC_ROOM)
		$(@el).append(JST['profile/ProfileAskForKey']())
		this
	askForKey:(event)->
		console.log("Bookmarks- Ask for "+@model.get('user_id')+' '+@model.get('firstname')+' key request from ME. (Who am I?)')