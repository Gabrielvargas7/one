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
		if(@model.get("FLAG_PROFILE") is "PUBLIC")
		 @bookmarksCollection.reset(@bookmarksCollection.first(9), silent:true)
		@bookmarksGridView = new Mywebroom.Views.ProfileActivityView2(collection:@bookmarksCollection,model:@model,headerName:"Bookmarks")
	render:->
		$(@el).html(@template(model:@model))
		#$(@el).append(JST['profile/ProfileGridTableHeader'](headerName:"Bookmarks"))
		$(@el).append(@bookmarksGridView.render().el)
		this
	askForKey:(event)->
		console.log("Bookmarks- Ask for "+@model.get('user_id')+' '+@model.get('firstname')+' key request from ME. (Who am I?)')