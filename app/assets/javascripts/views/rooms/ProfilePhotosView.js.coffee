class Mywebroom.Views.ProfilePhotosView extends Backbone.View
	tagName:'table'
	className:'user-photos-view'
	template: JST['profile/profileHomeGrid']
	initialize: ->

		@photosCollection = new Mywebroom.Collections.index_users_photos_by_user_id_by_limit_by_offset()
		@photosCollection.fetch
		    url: @photosCollection.url @model.get('user_id'),6,0
		    async:false
		    success: (response)->
		     console.log("PhotosCollection Fetched Successfully")
		     console.log(response)
	render: ->

		#this template will be the parent one which defines the table
		$(@el).html(@template(activity:@photosCollection))
		#Send first 3 models to row template. this view's template will define the rows
		slicedCollection = @photosCollection.first 3
		rowView = new Mywebroom.Views.ProfileGridRowView(collection:slicedCollection)
		$(@el).append(rowView.el)
		rowView.render()
		this
