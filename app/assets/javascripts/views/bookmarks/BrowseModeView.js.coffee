class Mywebroom.Views.BrowseModeView extends Backbone.View
	@modelToBrowse
	@browseSitesCollection
	className:"browse_mode_view"
	template:JST['bookmarks/BrowseModeTemplate']
	events:
		'click #browse_mode_site_nav_close':'closeView'
		'click #browse_mode_site_nav_minimize':'minimizeSite'
		'click #browse_mode_site_nav_refresh':'refreshSite'
	initialize:->
		a = 1
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
	closeView:(event)->
		this.trigger('browseModeClosed')
		this.remove()
	removeCurrentActiveSite:(target)->
		#remove current active site
		$(target).removeClass 'current_active_site'
	addCurrentActiveSite:(target)->
		$(target).addClass 'current_active_site' 
