class Mywebroom.Views.MyBookmarkGridItemView extends Backbone.View
	#*******************
	#**** Tag  (no tag = default el "div")
	#*******************
	tagName:"li"
	#*******************
	#**** Templeate
	#*******************
	template:JST['bookmarks/MyBookmarkGridItemView']

	events:
		'click .trash_icon_hover':'confirmDeleteBookmark'
		'click .gridItemPicture.my_bookmarks_grid_item':'triggerBrowseMode'
	#*******************
    #**** Render
    #*******************
	render:->
		$(@el).html(@template(model:@model))

	confirmDeleteBookmark:(event)->
		#Confirm to delete the bookmark.
		modalHTML = JST['bookmarks/ConfirmDeleteBookmarkModal'](model:@model)
		$(@el).append(modalHTML)
		$('#myModal').modal(backdrop:false)
		that=this
		#NOTE: This .on is jQuery NOT Backbone.on. 
		$('.delete_bookmark_button').on('click',{@model, that},
			->
			  that.trigger('deleteBookmark',that.model)
			  that.remove())
		#Destroy the modal instead of hide it, since we have changing data inside it. (model name)
		$("#myModal").on "hidden", ->
  			$('#myModal').remove()
	triggerBrowseMode:(event)->
		console.log "Welcome to browse mode! You are browsing:"
		console.log @model
		Mywebroom.vent.trigger('BrowseMode:open',{@model})
		Mywebroom.vent.trigger('BrowseMode:closeBookmarkView')
