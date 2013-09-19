class Mywebroom.Views.BrowseModeView extends Backbone.View
	@modelToBrowse
	className:"browse_mode_view"
	template:JST['bookmarks/BrowseModeTemplate']
	events:
		'click #browse_mode_site_nav_close':'closeView'
		'click #browse_mode_site_nav_minimize':'minimizeSite'
		'click #browse_mode_site_nav_refresh':'refreshSite'
		'click #browse_mode_active':'showActiveMenu'
		'click .active_menu_site_icon':'iconActiveSiteChange'
		'click #browse_mode_discover':'showDiscoverView'
		'click #browse_mode_bookmarks':'showBookmarksView'
		'click .browse_mode_sidebar_icons':'activeSiteChange'
		
	$currentActiveSiteHTML:->
		$('.current_browse_mode_site')
	$activeSites:->
		$('.browse_mode_site')
	initialize:->
		@activeSitesCollection=new Backbone.Collection()
	setModelToBrowse:(model)->
		@modelToBrowse=model
		#Fetch item+designs info (possibly rerender active menu when we're there)
	getModelToBrowse:->
		@modelToBrowse
	
	#render- The nature of this view is that render is called once. 
	#We frequently rerender the sidebar view. 
	render:->
		@browseModeSidebarView.remove() if @browseModeSidebarView
		@browseModeSidebarView = new Mywebroom.Views.BrowseModeSidebarView(model:@modelToBrowse)
		#$(@el).html(@browseModeSidebarView.render().el)
		$(@el).append(@template(model:@getModelToBrowse()))
	minimizeSite:(event)->
		console.log("minimize view")
		#Add to active sites by removing class 'current_active_site'
		@removeCurrentActiveSite(event.currentTarget)
		#Hide Active Sites View if it exists. 
		@activeMenuView.hideActiveMenu() if @activeMenuView
		#hide the view and go back to room.
		$(@el).hide()
	refreshSite:(event)->
		console.log "refresh site!"

	removeCurrentActiveSite:(target)->
		#remove current active site
		$(target).removeClass 'current_browse_mode_site'
	setCurrentActiveSite:(target)->
		$(target).addClass 'current_browse_mode_site' 
	showActiveMenu:-> 
		if !@activeMenuView
			console.log "BrowseMode showActiveMenu"
			#Create new active menu view
			@activeMenuView = new Mywebroom.Views.BrowseActiveMenuView(collection:@activeSitesCollection)
			$(@el).append(@activeMenuView.render().el)
			@activeMenuView.showActiveMenu()
		else
			@activeMenuView.showActiveMenu()
	showDiscoverView:->console.log "BrowseMode showDiscoverView"
	showBookmarksView:->console.log "BrowseMode showBookmarksView"

	#activeSiteChange is called each time a user clicks a bookmark. 
	#  It adds the new site to the collection and generates a new iframe
	activeSiteChange:(model)->
		if @activeSitesCollection.get(model)
			console.log "already here!"
			@setModelToBrowse @activeSitesCollection.get(model)
			@browseModeSidebarView.setModel @getModelToBrowse()
			@removeCurrentActiveSite(@$currentActiveSiteHTML())
			#set current active site to this model in iframe. 
			@setCurrentActiveSite $('.browse_mode_site[data-id='+model.get('id')+']')
		else
			@setModelToBrowse model
			#Add to active sites collection.
			@activeSitesCollection.add(model)
			#Remove current active site and add this one as current.
			@removeCurrentActiveSite(@$currentActiveSiteHTML())
			#Append it to the el. 

			newIframeHTML = JST['bookmarks/BrowseModeIframeTemplate'](model:@getModelToBrowse())
			$('.browse_mode_site_wrap').append(newIframeHTML)
			#rerender the sidebar menu if model id is different.
			@browseModeSidebarView.remove() if @browseModeSidebarView
			@browseModeSidebarView = new Mywebroom.Views.BrowseModeSidebarView(model:@modelToBrowse)
			$(@el).append(@browseModeSidebarView.render().el)
	#the model clicked is already part of activeSitesCollection
	iconActiveSiteChange:(event)->
		#get model and pass to activeSiteChange
		siteId= event.currentTarget.dataset.id
		@setModelToBrowse @activeSitesCollection.get(siteId)
		#rerender the sidebar menu (TODO- onlyif model id is different.)
		@browseModeSidebarView.remove() if @browseModeSidebarView
		@browseModeSidebarView = new Mywebroom.Views.BrowseModeSidebarView(model:@modelToBrowse)
		$(@el).append(@browseModeSidebarView.render().el)

		@removeCurrentActiveSite(@$currentActiveSiteHTML())
		#set current active site to this model in iframe. 
		@setCurrentActiveSite $('.browse_mode_site[data-id='+siteId+']') 
	closeView:->
		#remove current active site from the active sites list.
		$(@$currentActiveSiteHTML()).remove()
		#Remove the model from activeSitesCollection
		@activeSitesCollection.remove(@getModelToBrowse())
		#Hide Active Sites View if it exists. 
		@activeMenuView.hideActiveMenu() if @activeMenuView
		#Hide Browse Mode View
		$(@el).hide()	

