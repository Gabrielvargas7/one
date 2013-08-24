class Mywebroom.Views.ProfileObjectsView extends Backbone.View
	className:'profile_objects_view'
	template: JST['profile/ProfileObjectsTemplate']
	render: ->
		$(@el).html(@template(collection: @collection,model:@model))
		#append objects table.
		objectsTableView = new Mywebroom.Views.ProfileGridTableView(collection: @collection)
		$(@el).append(objectsTableView.render().el)
		this