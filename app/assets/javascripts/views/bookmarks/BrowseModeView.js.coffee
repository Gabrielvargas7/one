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
		'click #browse_mode_discover':'showBookmarksView'
		'click #browse_mode_bookmarks':'showBookmarksView'
		
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
	getActiveSitesCollection:->
		@activeSitesCollection
	
	#render- The nature of this view is that render is called once. 
	#We frequently rerender the sidebar view. 
	render:->
		@browseModeSidebarView.remove() if @browseModeSidebarView
		@browseModeSidebarView = new Mywebroom.Views.BrowseModeSidebarView(model:@modelToBrowse)
		#$(@el).html(@browseModeSidebarView.render().el)
		$(@el).append(@template(model:@getModelToBrowse()))

		this
	removeCurrentActiveSite:(target)->
		#remove current active site
		$(target).removeClass 'current_browse_mode_site'
	setCurrentActiveSite:(target)->
		$(target).addClass 'current_browse_mode_site' 
	showActiveMenu:-> 
		if !@activeMenuView
			console.log "BrowseMode showActiveMenu"
			#Create new active menu view
			@activeMenuView = new Mywebroom.Views.BrowseActiveMenuView(collection:@getActiveSitesCollection())
			$(@el).append(@activeMenuView.render().el)
			@activeMenuView.showActiveMenu()
		else
			@activeMenuView.showActiveMenu()

	showBookmarksView:(event)->
		#get model item-id, show that bookmark view.
		itemId = @modelToBrowse.get('item_id')
		userId = "24"
		bookmarksView = new Mywebroom.Views.BookmarksView({user_item_design:itemId,user:userId})
		$('#room_bookmark_item_id_container_'+itemId).append(bookmarksView.el)
		bookmarksView.render()
		if event.currentTarget is $('#browse_mode_discover')[0]
		  bookmarksView.renderDiscover()
		#hide this view
				#Hide Active Sites View if it exists. 
		@activeMenuView.hideActiveMenu() if @activeMenuView
		#Hide Browse Mode View
		$(@el).hide()	
		console.log "BrowseMode showBookmarksView"

	#activeSiteChange is called each time a user clicks a bookmark.
	#  It is also called when the user clicks a BrowseMode Sidebar icon.  
	#  It adds the new site to the collection and generates a new iframe
	activeSiteChange:(model)->
		#Check if the site is already active.
		if @getActiveSitesCollection().get(model)
			console.log "already here!"
			@setModelToBrowse @getActiveSitesCollection().get(model)
			@browseModeSidebarView.setModel @getModelToBrowse()
			@removeCurrentActiveSite(@$currentActiveSiteHTML())
			#set current active site to this model in iframe. 
			@setCurrentActiveSite $('.browse_mode_site[data-id='+model.get('id')+']')
		else
			@setModelToBrowse model
			#Add to active sites collection.
			@getActiveSitesCollection().add(model)
			#Remove current active site and add this one as current.
			@removeCurrentActiveSite(@$currentActiveSiteHTML())
			#Check if the site allows iframe
			if model.get('i_frame') is 'n'
				#open in target
				window.open model.get('bookmark_url'),"_blank"
				newIframeHTML = JST['bookmarks/BrowseModeNoIframeTemplate'](model:@getModelToBrowse())
			else	
				#Append it to the el.	
				newIframeHTML = JST['bookmarks/BrowseModeIframeTemplate'](model:@getModelToBrowse())
			$('.browse_mode_site_wrap').append(newIframeHTML)
			#rerender the sidebar menu if model id is different.
			@browseModeSidebarView.remove() if @browseModeSidebarView
			@browseModeSidebarView = new Mywebroom.Views.BrowseModeSidebarView(model:@modelToBrowse)
			@browseModeSidebarView.on('BrowseMode:sidebarIconClick',@activeSiteChange,this)
			$(@el).append(@browseModeSidebarView.render().el)
			@setSidebarHover();
				
			
	#Called when user clicks another site icon in the Active Menu
	#The model clicked is already part of activeSitesCollection
	iconActiveSiteChange:(event)->
		#get model and pass to activeSiteChange
		siteId= event.currentTarget.dataset.id
		@setModelToBrowse @getActiveSitesCollection().get(siteId)
		#rerender the sidebar menu (TODO- onlyif model id is different.)
		@browseModeSidebarView.remove() if @browseModeSidebarView
		@browseModeSidebarView = new Mywebroom.Views.BrowseModeSidebarView(model:@modelToBrowse)
		@browseModeSidebarView.on('BrowseMode:sidebarIconClick',@activeSiteChange,this)
		$(@el).append(@browseModeSidebarView.render().el)
		@removeCurrentActiveSite(@$currentActiveSiteHTML())
		#set current active site to this model in iframe. 
		@setCurrentActiveSite $('.browse_mode_site[data-id='+siteId+']') 
	
	#Called when the user clicks Refresh in the Browse Mode Nav.
	refreshSite:(event)->
		console.log "refresh site!"
		originalURL = $('.current_browse_mode_site').attr 'src'
		$('.current_browse_mode_site').attr 'src',originalURL
	
	#Called when user clicks Minimize in the Browse Mode Nav.
	minimizeSite:(event)->
		console.log("minimize view")
		#Add to active sites by removing class 'current_active_site'
		@removeCurrentActiveSite(event.currentTarget)
		#Hide Active Sites View if it exists. 
		@activeMenuView.hideActiveMenu() if @activeMenuView
		#hide the view and go back to room.
		$(@el).hide()

	#Called when user clicks Close in the Browse Mode Nav.
	#Note that the view is hidden. It is never removed/destroyed.
	closeView:->
		#remove current active site from the active sites list.
		$(@$currentActiveSiteHTML()).remove()
		#Remove the model from activeSitesCollection
		@getActiveSitesCollection().remove(@getModelToBrowse())
		#Hide Active Sites View if it exists. 
		@activeMenuView.hideActiveMenu() if @activeMenuView
		#Hide Browse Mode View
		$(@el).hide()	
	setSidebarHover:->
		$('#browse_mode_active_default').mouseover(->
			$('#browse_mode_active_highlight').show()
			$('#browse_mode_active_default').hide()
			)
		$('#browse_mode_active_highlight').mouseout(->
				$('#browse_mode_active_highlight').hide()
				$('#browse_mode_active_default').show()
			)
		$('#browse_mode_discover_default').mouseover(->
			$('#browse_mode_discover_highlight').show()
			$('#browse_mode_discover_default').hide()
			)
		$('#browse_mode_discover_highlight').mouseout(->
				$('#browse_mode_discover_highlight').hide()
				$('#browse_mode_discover_default').show()
			)
		$('#browse_mode_mybookmarks_default').mouseover(->
			$('#browse_mode_mybookmarks_highlight').show()
			$('#browse_mode_mybookmarks_default').hide()
			)
		$('#browse_mode_mybookmarks_highlight').mouseout(->
				$('#browse_mode_mybookmarks_highlight').hide()
				$('#browse_mode_mybookmarks_default').show()
			)
