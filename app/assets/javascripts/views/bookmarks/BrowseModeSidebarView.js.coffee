class Mywebroom.Views.BrowseModeSidebarView extends Backbone.View
	className:'browse_mode_sidebar'
	template:JST['bookmarks/BrowseModeSidebarTemplate']
	events:
		'click .browse_mode_sidebar_icons':'sideBarActiveSiteChange'
	initialize:->
		
	render:->
		if @model
			#fetch data here
			@itemBookmarksCollection = new Mywebroom.Collections.IndexUserBookmarksByUserIdAndItemIdCollection()
			@itemBookmarksCollection.fetch
			  url:@itemBookmarksCollection.url('24',@model.get('item_id'))
			  async:false;
			@collection = @itemBookmarksCollection.first(4)
			@model.on('change',@render,this)
		$(@el).html(@template(collection:@collection,model:@model))
		this
	setModel:(model)->
		@model.set(model.toJSON())
	sideBarActiveSiteChange:(event)->
		console.log 'sidebar active site change. '
		event.stopPropagation()
		modelId= event.currentTarget.dataset.id
		modelClicked = @itemBookmarksCollection.get(modelId)
		#trigger an event pass model up.
		this.trigger 'BrowseMode:sidebarIconClick', modelClicked
