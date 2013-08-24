class Mywebroom.Views.ProfileGridTableView extends Backbone.View
	tagName:'table'
	className:'profile_grid_table_view'
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

class Mywebroom.Views.ProfileTableOuterDivView extends Backbone.View
	tagName:'div'
	className:'profile_table_outerDiv'
	render:->
		$(@el).html('')
		#outer creates inner
		innerView = new Mywebroom.Views.ProfileTableInnerDivView()
		$(@el).append(innerView.render().el)
class Mywebroom.Views.ProfileTableInnerDivView extends Backbone.View
	tagName:'div'
	className:'profile_table_innerDiv'
	render:->
		$(@el).html('')
		#inner creates table