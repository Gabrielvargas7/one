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
		Mywebroom.State.set('activeSitesMenuView', this)
	render:->
		$(@el).html(@template(collection:@collection))
		this
	hideActiveMenu:->
		$(@el).css "left","-2070px"
		$('#browse_mode_active_highlight').hide()
		$('#browse_mode_active_default').show()
		$('.browse_mode_site_nav').css 'top',5
	showActiveMenu:->
		$(@el).css "left","70px"
		$('#browse_mode_active_default').unbind('mouseover')
		$('#browse_mode_active_highlight').unbind('mouseout')
		$('#browse_mode_active_highlight').show()
		$('#browse_mode_active_default').hide()
		$('.browse_mode_site_nav').css 'top',82