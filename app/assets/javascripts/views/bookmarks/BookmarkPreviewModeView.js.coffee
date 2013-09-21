class Mywebroom.Views.BookmarkPreviewModeView extends Backbone.View
	className:"preview_mode_wrap"
	template:JST['bookmarks/BookmarkPreviewModeTemplate']
	events:
		'click .preview_mode_title .close_button':'closeView'
	render:->
		$(@el).html(@template(model:@model))
		#Sidebar Preview Template
		sidebarPreviewHTML=JST['bookmarks/BookmarkSidebarPreviewMode'](model:@model)
		$('.bookmark_menu').append(sidebarPreviewHTML)
		$('.discover_submenu_section').hide()
		$(@el).css "width",$(window).width()-$('.bookmark_menu').width()
		$(@el).css "left",$('.bookmark_menu').width()
		this
	closeView:->
		this.trigger('closedView')
		#Close SidebarPreview Template
		$('#bookmark_sidebar_preview_mode').remove()
		$('.discover_submenu_section').show()
		this.remove()