class Mywebroom.Views.MyBookmarkGridItemView extends Backbone.View
	#*******************
	#**** Tag  (no tag = default el "div")
	#*******************
	tagName:"li"
	#*******************
	#**** Templeate
	#*******************
	template:JST['bookmarks/MyBookmarkGridItemView']
	#*******************
    #**** Render
    #*******************
	render:->
		$(@el).html(@template(model:@model))
