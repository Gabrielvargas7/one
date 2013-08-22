class Mywebroom.Views.RoomView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

  el: '#xroom'

  #*******************
  #**** Templeate
  #*******************

  template: JST['rooms/RoomTemplate']

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
    this.getRoomLoadingUserCollection()
    this.getUserSignInCollection()

  #*******************
  #**** Render
  #*******************
  render: ->

    @userRoomModel = @userRoomCollection.first() #username and id

    if @userRoomModel.id is undefined
      this.forwardToRoot()
    else
      this.getUserDataCollection(@userRoomModel.get('id'))
      @userAllRoomDataModel = @userAllRoomDataCollection.first() #user data
      console.log("userAllRoomDataModel: ")
      console.log(@userAllRoomDataModel)

      this.setRoomTheme @userAllRoomDataModel
      this.setRoomItemsDesigns @userAllRoomDataModel
      this.setRoomHeader()

    this


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
    @userRoomCollection = new Mywebroom.Collections.ShowRoomUserCollection()
    this.userRoomCollection.fetch async: false
    console.log("fetch userRoomCollection: "+JSON.stringify(this.userRoomCollection.toJSON()))


  #--------------------------
  # get the sign in user  if exist
  #--------------------------
  getUserSignInCollection: ->
    @userSignInCollection = new Mywebroom.Collections.ShowSignedUserCollection()
    @userSignInCollection.fetch async: false
    console.log("fetch userSignInCollection: "+JSON.stringify(@userSignInCollection.toJSON()))

  #--------------------------
  # get the user room info
  #--------------------------
  getUserDataCollection:(userId) ->
    @userAllRoomDataCollection = new Mywebroom.Collections.ShowRoomByUserIdCollection()
    @userAllRoomDataCollection.fetch
      url:@userAllRoomDataCollection.url userId
      async:false
      success: (response)->
        console.log("@userAllRoomDataCollection: ")
        console.log(response)
#        console.log("@userAllRoomDataCollection: "+JSON.stringify(response.toJSON()))


  #--------------------------
  # set items designs on id = #xroom_items
  #--------------------------
  setRoomHeader: ->
    roomHeaderView = new Mywebroom.Views.RoomHeaderView()
    $('#xroom_header').append(roomHeaderView.el)
    roomHeaderView.render()


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
      #console.log(userItemsDesignsList[i].id)
      userItemsDesignsView = new Mywebroom.Views.RoomUserItemsDesignsView({user_item_design:userItemsDesignsList[i]})
      $('#xroom_items').append(userItemsDesignsView.el)
      userItemsDesignsView.render()
      i++


  #*******************
  #**** Funtions Social
  #*******************


  #--------------------------
  #  *** function showProfile
  #--------------------------
  showProfile: (evt) ->
    @profile = new Backbone.Model
    @profile.set(@userAllRoomDataModel.get('user_profile'))
    @profile.set('user',@userAllRoomDataModel.get('user'))
    @profile.set('user_photos',@userAllRoomDataModel.get('user_photos'))
    @showProfileView()


  #--------------------------
  #  *** function showProfileView
  #--------------------------
  showProfileView: ->
    @profileView = new Mywebroom.Views.ProfileHomeView(
      model:@profile
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
