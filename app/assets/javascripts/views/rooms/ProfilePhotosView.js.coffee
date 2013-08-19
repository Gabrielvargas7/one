class Mywebroom.Views.ProfilePhotosView extends Backbone.View
	tagName:'table'
	className:'user-photos-view'
	template: JST['profile/profileHomeGrid']
	render: ->
		#this template will be the parent one which defines the table
		$(@el).html(@template(activity:@collection))
		#Send first 3 models to row template. this view's template will define the rows
		slicedCollection = @collection.first 3
		rowView = new Mywebroom.Views.ProfileGridRowView(collection:slicedCollection)
		$(@el).append(rowView.el)
		rowView.render()
		this
