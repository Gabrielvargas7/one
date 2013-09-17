class Mywebroom.Views.BrowseModeSidebarView extends Backbone.View
	className:'browse_mode_sidebar'
	template:JST['bookmarks/BrowseModeSidebarTemplate']
	initialize:->
		if @model
			#fetch data here
			itemBookmarksCollection = new Mywebroom.Collections.IndexUserBookmarksByUserIdAndItemIdCollection()
			itemBookmarksCollection.fetch
			  url:itemBookmarksCollection.url('24',@model.get('item_id'))
			  async:false;
			@collection = itemBookmarksCollection.first(4)
	render:->
		$(@el).html(@template(collection:@collection))
		this