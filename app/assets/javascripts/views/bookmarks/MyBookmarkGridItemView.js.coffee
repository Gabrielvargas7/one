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
		'click .trash_icon_hover':'deleteBookmark'
	#*******************
    #**** Render
    #*******************
	render:->
		$(@el).html(@template(model:@model))

	deleteBookmark:(event)->
		#Call API to delete Bookmark. Trigger a change 
		this.trigger('deleteBookmark',@model)
		this.remove()
