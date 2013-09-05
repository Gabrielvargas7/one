class Mywebroom.Views.BookmarkPreviewModeView extends Backbone.View
	className:"preview_mode_wrap"
	template:JST['bookmarks/BookmarkPreviewModeTemplate']
	events:
		'click .preview_mode_title .close_button':'closeView'
	render:->
		$(@el).html(@template(model:@model))
		this
	closeView:->
		this.trigger('closedView')
		this.remove()