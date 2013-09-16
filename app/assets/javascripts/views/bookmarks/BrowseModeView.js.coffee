class Mywebroom.Views.BrowseModeView extends Backbone.View
	@modelToBrowse
	@browseSitesCollection
	className:"browse_mode_view"
	template:JST['bookmarks/BrowseModeTemplate']
	events:
		'click #browse_mode_site_nav_close':'closeView'
		'click #browse_mode_site_nav_minimize':'minimizeSite'
		'click #browse_mode_site_nav_refresh':'refreshSite'
		'click #browse_mode_active':'showActiveMenu'
		'click #browse_mode_discover':'showDiscoverView'
		'click #browse_mode_bookmarks':'showBookmarksView'
		'click #browse_mode_active_site_icon':'activeSiteChange'
		'click .browse_mode_item_designs_bookmark_icon':'activeSiteChange'
	initialize:->
		console.log "hi I'm a browse mode view"
		#Create activeSitesCollection 
		#No, cause we close this view. 
	render:->
		$(@el).html(@template())
	minimizeSite:(event)->
		console.log("minimize view")
		#Add to active sites by removing class 'current_active_site'
		@removeCurrentActiveSite(event.currentTarget)
		#hide the view and go back to room.
		this.trigger('browseModeClosed')
		$(@el).hide()
	refreshSite:(event)->
		console.log "refresh site!"

	removeCurrentActiveSite:(target)->
		#remove current active site
		$(target).removeClass 'current_active_site'
	addCurrentActiveSite:(target)->
		$(target).addClass 'current_active_site' 
	showActiveMenu:-> console.log "BrowseMode showActiveMenu"
	showDiscoverView:->console.log "BrowseMode showDiscoverView"
	showBookmarksView:->console.log "BrowseMode showBookmarksView"
	activeSiteChange:->
		console.log "BrowseMode activeSiteChange"
		#Need to change active model out. 
	closeView:(event)->
		this.trigger('browseModeClosed')
		this.remove()	

