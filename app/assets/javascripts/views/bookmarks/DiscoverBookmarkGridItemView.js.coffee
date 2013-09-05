class Mywebroom.Views.DiscoverBookmarkGridItemView extends Backbone.View
	#*******************
	#**** Tag  (no tag = default el "div")
	#*******************
	tagName:"li"
	#*******************
	#**** Templeate
	#*******************
	template:JST['bookmarks/DiscoverGridItemTemplate']
	#*******************
    #**** Render
    #*******************
	render:->
		$(@el).html(@template(model:@model))
