class Mywebroom.Views.RoomView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

  el: '#xroom'

  #*******************
  #**** Templeate
  #*******************

  template: JST['rooms/XRoomTemplate']

  #*******************
  #**** Events
  #*******************

  events:{
    'click #xroom_menu_profile':'showProfile'
  }
#  **********************
#  *** function showProfile
#  **********************

  initialize: ->
    @collection.on('reset', @render, this)
    @theme_collection = new Mywebroom.Collections.RoomsJsonShowRoomByUserId()
#    @theme_collection.on('reset_theme', @render_theme, this)
    
    #Can't get activity collection to wait for fetch if
    # it's in ProfileHomeModel
    @activityCollection = new Mywebroom.Collections.index_notification_by_limit_by_offset()
    @photosCollection = new Mywebroom.Collections.index_users_photos_by_user_id_by_limit_by_offset()
    @friendsCollection = new Mywebroom.Collections.Index_Friend_By_User_Id_By_Limit_By_Offset()
    @keyRequestsCollection = new Mywebroom.Collections.Index_Friend_Request_Make_From_Your_Friend_To_You_By_User_Id()

    this.getRoomLoadingUserCollection()
    this.getUserSignInCollection()



  #*******************
  #**** Render
  #*******************
  render: ->

    @userRoomModel = @userRoomCollection.first()

    if @userRoomModel.id is undefined
      this.forwardToRoot()
    else
      this.getUserDataCollection()
      @userAllRoomDataModel = @userAllRoomDataCollection.first()

      this.setRoomTheme @userAllRoomDataModel
      this.setRoomItemsDesigns @userAllRoomDataModel



  #    $(@el).html(@template(user: @collection))
    #Once collection is done, we want to fetch the theme by user id.
    # so set the url for theme collection to the user id
    if @collection.models.length
      console.log("UsersJsonShowSignedUser has a model. Fetching ThemeCol data");
      loggedInUserId=@collection.models[0].get('id')
      #Fetch Theme data
      @theme_collection.fetch
        url:'/rooms/json/show_room_by_user_id/'+loggedInUserId
        reset_theme: true
#        success: (response)->
#          console.log(response)
#          if response.models
#            response.models[0].collection.trigger('reset_theme')
      #Fetch activity data for Profile

      @activityCollection.fetch
        reset:true
        success: (response)->
          console.log("ActivityCollection Fetched Successfully Response:")
          console.log(response)
          console.log('response.attributes: ')
          console.log(response.attributes)
      #Fetch photos data for Profile Photos
      @photosCollection
      @photosCollection.fetch
        url:'/users_photos/json/index_users_photos_by_user_id_by_limit_by_offset/'+loggedInUserId+'/6/0.json'
        reset:true
        success: (response)->
         console.log("PhotosCollection Fetched Successfully")
         console.log(response)
      #Fetch friends data for Profile Friends
      @friendsCollection.fetch
        url:'/friends/json/index_friend_by_user_id_by_limit_by_offset/'+loggedInUserId+'/6/0.json'
        reset:true
        success: (response)->
         console.log("FriendsCollection Fetched Successfully")
         console.log(response)
      #Fetch friends data for Profile Friends
      @keyRequestsCollection.fetch
        url:'/friend_requests/json/index_friend_request_make_from_your_friend_to_you_by_user_id/'+loggedInUserId+'.json'
        reset:true
        success: (response)->
         console.log("KeyRequestsCollection Fetched Successfully")
         console.log(response)
    this


  #*******************
  #**** Funtions  Start Room
  #*******************

#  render_theme: ->
#    @themeView = new Mywebroom.Views.RoomThemeView(collection: @theme_collection)
#    $('#c').append(@themeView.el)
#    @themeView.render()
#    this


  #*******************
  #**** Funtions  Start Room
  #*******************

  #--------------------------
  # forward to the origin url if the user does't exist -> ex: 'http://www.mywebroom.com/'
  #--------------------------
  forwardToRoot: ->
    origin = window.location.origin
    console.log("forward to: "+origin)
    window.location.href = origin

  #--------------------------
  # get the user of the room that is loading
  #--------------------------
  getRoomLoadingUserCollection: ->
    @userRoomCollection = new Mywebroom.Collections.XRoomsShowRoomUserCollection()
    this.userRoomCollection.fetch async: false
    console.log("fetch userRoomCollection: "+JSON.stringify(this.userRoomCollection.toJSON()))


  #--------------------------
  # get the sign in user  if exist
  #--------------------------
  getUserSignInCollection: ->
    @userSignInCollection = new Mywebroom.Collections.XUsersJsonShowSignedUserCollection()
    @userSignInCollection.fetch async: false
    console.log("fetch userSignInCollection: "+JSON.stringify(@userSignInCollection.toJSON()))


  #--------------------------
  # get the user room info
  #--------------------------
  getUserDataCollection: ->
    @userAllRoomDataCollection = new Mywebroom.Collections.XRoomsJsonShowRoomByUserIdCollection()
    console.log("user defined: "+JSON.stringify(@userRoomModel.toJSON()))
    @userAllRoomDataCollection.user_id = @userRoomModel.get('id')
    @userAllRoomDataCollection.fetch async: false

  #--------------------------
  # set theme on id = #xroom
  #--------------------------
  setRoomTheme: (userAllRoomDataModel) ->
    userThemeList = userAllRoomDataModel.get('user_theme')
    userTheme = userThemeList[0]
    $(@el).append(@template(user_theme:userTheme))


  #--------------------------
  # set items designs on id = #xroom_items
  #--------------------------
  setRoomItemsDesigns: (userAllRoomDataModel) ->
    userItemsDesignsList = userAllRoomDataModel.get('user_items_designs')
    length = userItemsDesignsList.length
    i = 0
    while i < length
      console.log(userItemsDesignsList[i].id)
      userItemsDesignsView = new Mywebroom.Views.XRoomUserItemsDesignsView({user_item_design:userItemsDesignsList[i]})
      $('#xroom_items').append(userItemsDesignsView.el)
      userItemsDesignsView.render()
      i++


  #*******************
  #**** Funtions  Profile
  #*******************

  homeProfile: ->
    console.log("Create ProfileView ")
    userProfileHomeView = new Mywebroom.Views.XProfileHomeView()
    $('#xroom_profile').append(userProfileHomeView.el)
    userProfileHomeView.render()


  #--------------------------
  #  *** function showProfile
  #--------------------------
  showProfile: (evt) ->
        #TODO Move this to the model initialize
    @profile = new Mywebroom.Models.ProfileHome({msg:"Hello user"})
    @profile.set(@theme_collection.models[0].get('user_profile'))
    @profile.set('user',@theme_collection.models[0].get('user'))
    @profile.set('user_photos',@theme_collection.models[0].get('user_photos'))
    @showProfileView()


  #--------------------------
  #  *** function showProfileView
  #--------------------------
  showProfileView: ->
    console.log("ShowProfileView fun")
    @profileView = new Mywebroom.Views.ProfileHomeView(
      model:@profile
      activityCollection:@activityCollection
      photosCollection:@photosCollection
      friendsCollection:@friendsCollection
      keyRequestsCollection:@keyRequestsCollection
    )
    $('#xroom_profile').append(@profileView.el)
    @profileView.render()


  #--------------------------
  #  *** function closeProfileView
  #--------------------------
  closeProfileView: ->
    console.log('CloseProfileView Function running')
    @profileView.remove();
    #Need to listen for #ProfileOpen again
    #Need to enable other room events again.
