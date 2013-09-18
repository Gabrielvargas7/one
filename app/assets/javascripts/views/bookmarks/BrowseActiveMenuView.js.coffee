class Mywebroom.Views.BrowseActiveMenuView extends Backbone.View
	className:'browse_mode_active_sites_menu'
	template:JST['bookmarks/BrowseActiveMenuTemplate']
	render:->
		$(@el).html(@template(collection:@collection))
		this
	hideActiveMenu:->
		$(@el).hide()
	showActiveMenu:->
		$(@el).show()