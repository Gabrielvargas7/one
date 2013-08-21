class Mywebroom.Views.ProfilePhotosView extends Backbone.View
	tagName:'table'
	className:'user-photos-view'
	template: JST['profile/ProfileHomeGrid']
	initialize: ->
		@photosCollection = new Mywebroom.Collections.IndexUsersPhotosByUserIdByLimitByOffsetCollection()
		@photosCollection.fetch
		    url: @photosCollection.url @model.get('user_id'),6,0
		    async:false
		    success: (response)->
		     console.log("PhotosCollection Fetched Successfully")
		     console.log(response)
	render: ->
		#this template will be the parent one which defines the table
		$(@el).html(@template(activity:@photosCollection))
		# k=0
		# rowArray= []
		# console.log("@photosCollection.models.length: "+@photosCollection.models.length)
		# while k < @photosCollection.models.length
		#   i = 0
		#   while i < 3
		#     rowArray.push @photosCollection.at k  if k < @photosCollection.models.length
		#     k+=1
		#     i++
		#   rowView = new Mywebroom.Views.ProfileGridRowView(collection: @rowArray)
		#   $(@el).append rowView.el
		#   rowView.render()
		#   rowArray.length = 0

		#Send first 3 models to row template. this view's template will define the rows
		slicedCollection = @photosCollection.first 3
		rowView = new Mywebroom.Views.ProfileGridRowView(collection:slicedCollection)
		$(@el).append(rowView.el)
		rowView.render()
		this
