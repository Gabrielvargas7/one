class Mywebroom.Views.BrowseModeView extends Backbone.View
	@modelToBrowse
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
	$currentActiveSiteHTML:->
		$('.current_browse_mode_site')
	$activeSites:->
		$('.browse_mode_site')
	initialize:->
		console.log "hi I'm a browse mode view"
		@activeSitesArray=[]
			
		#Create activeSitesCollection 
		#No, cause we close this view. 
	setModelToBrowse:(model)->
		@modelToBrowse=model
		#Fetch item+designs info (possibly rerender active menu when we're there)
	getModelToBrowse:->
		@modelToBrowse

	render:->
		@browseModeSidebarView.remove() if @browseModeSidebarView
		@browseModeSidebarView = new Mywebroom.Views.BrowseModeSidebarView(model:@modelToBrowse)
		$(@el).html(@browseModeSidebarView.render().el)
		$(@el).append(@template(model:@getModelToBrowse(),activeSitesArray:@activeSitesArray))
	minimizeSite:(event)->
		console.log("minimize view")
		#Add to active sites by removing class 'current_active_site'
		@removeCurrentActiveSite(event.currentTarget)
		#hide the view and go back to room.
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
	activeSiteChange:(model)->
		console.log "BrowseMode activeSiteChange"
		@setModelToBrowse model
		#Add to active sites collection.
		@activeSitesArray.push(model)
		#Remove current active site and add this one as current.
		@removeCurrentActiveSite(@$currentActiveSiteHTML())
		#Append it to the el. 
		newIframeHTML = "<iframe class='current_browse_mode_site browse_mode_site' src='http://www.about.com'></iframe>"
		$('.browse_mode_site_wrap').append(newIframeHTML)
		#rerender the sidebar menu if model id is different.
		@render()

	closeView:(event)->
		#remove current active site from the active sites list.
		$(@$currentActiveSiteHTML()).remove()
		#NEED TO REMOVE FROM ACTIVE SITES LIST
		$(@el).hide()	

