class Mywebroom.Views.BrowseModeSidebarView extends Backbone.View
	className:'browse_mode_sidebar'
	template:JST['bookmarks/BrowseModeSidebarTemplate']
	events:
		'click .browse_mode_sidebar_icons':'sideBarActiveSiteChange'
	initialize:->
		this.on('render',@setScroll)
		
	render:->
		if @model
			#fetch data here
			@collection = new Mywebroom.Collections.IndexUserBookmarksByUserIdAndItemIdCollection()
			@collection.fetch
			  url:@collection.url(Mywebroom.State.get('signInUser').get('id'),@model.get('item_id'))
			  async:false;
			#@collection = @itemBookmarksCollection.first(4)
			@model.on('change',@render,this)
		$(@el).html(@template(collection:@collection,model:@model))
		#@setScroll()
		this
	setModel:(model)->
		@model.set(model.toJSON())
	sideBarActiveSiteChange:(event)->
		console.log 'sidebar active site change. '
		debugger;
		event.stopPropagation()
		modelId= event.currentTarget.dataset.id
		modelClicked = @collection.get(modelId)
		#trigger an event pass model up.
		this.trigger 'BrowseMode:sidebarIconClick', modelClicked
	#Create SimplyScroll event for mybookmarks sidebar
	#Hope it dies quickly when the view closes
	setScroll:->
		console.log 'one day i will scroll things beautifully.'
		#Determine if we need to scroll.
		#
		if @collection.length > 5
			$("#browse_mode_scroller").simplyScroll
			  customClass: "vert"
			  orientation: "vertical"
			  auto: false
			  manualMode: "loop"
			  frameRate: 20
			  speed: 5

