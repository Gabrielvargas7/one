class Mywebroom.Views.BrowseModeView extends Backbone.View
	@modelToBrowse
	@browseSitesCollection
	className:"browse_mode_view"
	template:JST['bookmarks/BrowseModeTemplate']
	events:
		'click #browse_mode_site_nav_close':'closeView'
	initialize:->
		a = 1
	render:->
		$(@el).html(@template())
	closeView:(event)->
		this.trigger('browseModeClosed')
		this.remove()
