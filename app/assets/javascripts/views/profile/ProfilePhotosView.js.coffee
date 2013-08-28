class Mywebroom.Views.ProfilePhotosView extends Backbone.View
	tagName:'div'
	className:'user-photos-view'
	template: JST['profile/ProfilePhotosTemplate']
	events:
		'click #profile_ask_for_key_overlay button':'askForKey'

	initialize: ->
		@photosCollection = new Mywebroom.Collections.IndexUsersPhotosByUserIdByLimitByOffsetCollection()
		#If global flag, fetch 9 instead
		fetchLimit = 24
		@photosCollection.fetch
		    url: @photosCollection.url @model.get('user_id'),fetchLimit,0
		    async:false
		    success: (response)->
		     console.log("PhotosCollection Fetched Successfully")
		     console.log(response)
		#if(@model.FLAG_PROFILE is Mywebroom.Views.RoomView.PUBLIC_ROOM)
		 @photosCollection.reset(@photosCollection.first(9), silent:true)
	
	render: ->
		#FOR TESTING ONLY- set flag profile
		@model.set 'FLAG_PROFILE', Mywebroom.Views.RoomView.PUBLIC_ROOM
		$(@el).html(@template(collection:@photosCollection, model:@model))
		#create table with data
		tableView = new Mywebroom.Views.ProfileTableOuterDivView(collection: @photosCollection, model:@model)
		$(@el).append(tableView.render().el)
		#if(@model.FLAG_PROFILE is Mywebroom.Views.RoomView.PUBLIC_ROOM)
		#if @photosCollection.length > 6
		#	$(@el).append(JST['profile/ProfileAskForKey']())
		this
	askForKey:(event)->
		console.log("Photos- Ask for "+@model.get('user_id')+' '+@model.get('firstname')+' key request from ME. (Who am I?)')
