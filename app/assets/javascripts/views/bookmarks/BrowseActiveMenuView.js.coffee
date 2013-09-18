class Mywebroom.Views.BrowseActiveMenuView extends Backbone.View
	className:'browse_mode_active_sites_menu'
	template:JST['bookmarks/BrowseActiveMenuTemplate']
	initialize:->
		self= this
		@collection.on('add',@render,self)
		@collection.on('remove',@render,self)
	render:->
		$(@el).html(@template(collection:@collection))
		this
	hideActiveMenu:->
		$(@el).css "left","-2070px"
	showActiveMenu:->
		$(@el).show()