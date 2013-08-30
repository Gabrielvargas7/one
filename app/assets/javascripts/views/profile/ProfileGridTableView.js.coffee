#This file is used to create a table nested within an Outer Div and an Inner Div.
#The styling of the divs allows table scrolling without the title bar moving.
#If you want a table header title, create the ProfileGridTableHeader TEMPLATE first.
#Then append this view AFTER it.
#Create this view with the Outer table and pass your collection and model to it. 
class Mywebroom.Views.ProfileTableOuterDivView extends Backbone.View
	tagName:'div'
	className:'profile_table_outerDiv'
	render:->
		$(@el).html('')
		#outer creates inner
		innerView = new Mywebroom.Views.ProfileTableInnerDivView(collection: @collection,model:@model)
		$(@el).append(innerView.render().el)
		if @model and @model.get('FLAG_PROFILE') is Mywebroom.Views.RoomView.PUBLIC_ROOM
			#append ask for key overlay.
			$(@el).append(JST['profile/ProfileAskForKey']())
		this

class Mywebroom.Views.ProfileTableInnerDivView extends Backbone.View
	tagName:'div'
	className:'profile_table_innerDiv'
	render:->
		$(@el).html('')
		#inner creates table
		tableView = new Mywebroom.Views.ProfileGridTableView(collection: @collection,model:@model)
		$(@el).append(tableView.render().el)
		this

class Mywebroom.Views.ProfileGridTableView extends Backbone.View
	tagName:'table'
	className:'profile_grid_table_view generalGrid'
	initialize:->
	render:->
		$(@el).html('')
		#Split collection into rows of three and send them to GridRowView (which goes to GridItemView)
		k=0
		rowArray= []
		console.log("@collection.models.length: "+@collection.models.length)
		while k < @collection.models.length
		  i = 0
		  while i < 3
		    rowArray.push @collection.at k  if k < @collection.models.length
		    k+=1
		    i++
		  rowView = new Mywebroom.Views.ProfileGridRowView(collection: rowArray)
		  $(@el).append rowView.el
		  rowView.render()
		  rowArray.length = 0
		this
