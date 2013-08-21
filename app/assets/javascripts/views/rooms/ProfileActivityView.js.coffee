class Mywebroom.Views.ProfileActivityView extends Backbone.View
	tagName:'table'
	className: 'profileHome_activity generalGrid'
	template: JST['profile/ProfileHomeGrid']
	
	initialize: ->
		
	render: ->
		#this template will be the parent one which defines the table
		$(@el).html(@template(activity:@collection))
		#Send first 3 models to row template. this view's template will define the rows
		slicedCollection = @collection.first 3
		rowView = new Mywebroom.Views.ProfileGridRowView(collection:slicedCollection)
		$(@el).append(rowView.el)
		rowView.render()
		# for each item in @collection
		# 	rowView = new Mywebroom.Views.ProfileGridRow(collection:item)
		# 	$(@el).append(rowView.el)
		# 	rowView.render()

		#Send next 3 model to row template 
		#Should template iterate over collection 
		#	or should a separate grid item view be created?
	# showSocialBarView:(event)->
 #  		console.log("showSocialBarView function runs")
 #  		clickedModel = this.collection.get(event.currentTarget.dataset.id)
 #  		#model is undefined here. Get the specific model hovered over
 #  		socialBarView = new Mywebroom.Views.SocialBarView(model:clickedModel)
 #  		$(@el).append(socialBarView.el)
 #  		socialBarView.render() 
 # 	closeSocialBarView:->
 #  		console.log("closeSocialBarView functio runs")