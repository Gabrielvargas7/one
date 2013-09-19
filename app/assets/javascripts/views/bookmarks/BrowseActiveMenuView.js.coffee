#Active Menu instance hides and shows by altering the css left property. 
#This lets the menu slide out from right to left. 
class Mywebroom.Views.BrowseActiveMenuView extends Backbone.View
	className:'browse_mode_active_sites_menu'
	template:JST['bookmarks/BrowseActiveMenuTemplate']
	events:
		'click #active_menu_close':'hideActiveMenu'
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
		$(@el).css "left","70px"