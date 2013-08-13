class Mywebroom.Views.RoomsIndex extends Backbone.View

  template: JST['rooms/index']
  events:{
  	'click #ProfileOpen':'showProfile',
  	
  }
  showProfile: (evt) ->
    #TODO Move this to the model initialize
    @profile = new Mywebroom.Models.ProfileHome({msg:"Hello user"})
    @profile.set(@theme_collection.models[0].get('user_profile'))
    @profile.set('user',@theme_collection.models[0].get('user'))
    @profile.set('user_photos',@theme_collection.models[0].get('user_photos'))
    
    @showProfileView()

    #I had a lot of issues when trying to create the Profile View here. 
    #Got a white screen on loading, no errors. 
    #Not sure why this wouldn't run if view is created right after model is.
    
  	#@profileView = new Mywebroom.Views.ProfileHomeView({model:@profile})
  	#$(@el).append(@profileView.el)
  	#@profileView.render()
  	#Need to stop listening to other room events (hover objects,etc)
    # Objects are initialized int room_router.js.coffee. how do I get that model to stop listening?
  	#Need to stop listening for click #ProfileOpen
  showProfileView: ->
    console.log("ShowProfileView fun")
    @profileView = new Mywebroom.Views.ProfileHomeView(
      model:@profile
      activityCollection:@activityCollection
      photosCollection:@photosCollection
      friendsCollection:@friendsCollection
      keyRequestsCollection:@keyRequestsCollection
      )
    $(@el).append(@profileView.el)
    @profileView.render()
  closeProfileView: ->
  	console.log('CloseProfileView Function running')
  	@profileView.remove();	
  	#Need to listen for #ProfileOpen again
  	#Need to enable other room events again.

  initialize: ->
    @collection.on('reset', @render, this)
    @theme_collection = new Mywebroom.Collections.RoomsJsonShowRoomByUserId()
    @theme_collection.on('reset_theme', @render_theme, this)
    
    #Can't get activity collection to wait for fetch if
    # it's in ProfileHomeModel
    @activityCollection = new Mywebroom.Collections.index_notification_by_limit_by_offset()
    @photosCollection = new Mywebroom.Collections.index_users_photos_by_user_id_by_limit_by_offset()
    @friendsCollection = new Mywebroom.Collections.Index_Friend_By_User_Id_By_Limit_By_Offset()
    @keyRequestsCollection = new Mywebroom.Collections.Index_Friend_Request_Make_From_Your_Friend_To_You_By_User_Id()


  render: ->
    $(@el).html(@template(user: @collection))
    #Once collection is done, we want to fetch the theme by user id.
    # so set the url for theme collection to the user id
    if @collection.models.length 
      console.log("UsersJsonShowSignedUser has a model. Fetching ThemeCol data");
      loggedInUserId=@collection.models[0].get('id')
      #Fetch Theme data
      @theme_collection.fetch
        url:'/rooms/json/show_room_by_user_id/'+loggedInUserId
        reset_theme: true 
        success: (response)->
          console.log(response)
          if response.models
            response.models[0].collection.trigger('reset_theme')
      #Fetch activity data for Profile
      @activityCollection.fetch
        reset:true
        success: (response)-> 
          console.log("ActivityCollection Fetched Successfully Response:")
          console.log(response)
          console.log('response.attributes: ')
          console.log(response.attributes)
      #Fetch photos data for Profile Photos
      @photosCollection.fetch
        url:'/users_photos/json/index_users_photos_by_user_id_by_limit_by_offset/'+loggedInUserId+'/6/0.json'
        reset:true;
        success: (response)->
         console.log("PhotosCollection Fetched Successfully")
         console.log(response)
      #Fetch friends data for Profile Friends
      @friendsCollection.fetch
        url:'/friends/json/index_friend_by_user_id_by_limit_by_offset/'+loggedInUserId+'/6/0.json'
        reset:true;
        success: (response)->
         console.log("FriendsCollection Fetched Successfully")
         console.log(response)
      #Fetch friends data for Profile Friends
      @keyRequestsCollection.fetch
        url:'/friend_requests/json/index_friend_request_make_from_your_friend_to_you_by_user_id/'+loggedInUserId+'.json'
        reset:true;
        success: (response)->
         console.log("KeyRequestsCollection Fetched Successfully")
         console.log(response)
    this
  render_theme: ->
    @themeView = new Mywebroom.Views.RoomThemeView(collection: @theme_collection)
    $('#c').append(@themeView.el)
    @themeView.render()
    this

