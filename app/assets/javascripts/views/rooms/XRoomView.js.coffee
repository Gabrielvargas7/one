class Mywebroom.Views.XRoomView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Templeate
  #*******************
  template: JST['rooms/XRoomTemplate']

  #*******************
  #**** Events
  #*******************
  events:
    'click #xroom_profile_open':'showProfile'


  #*******************
  #**** Initialize
  #*******************
  initialize: ->
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
  # set theme on room
  #--------------------------
  setRoomTheme: (userAllRoomDataModel) ->
    userThemeList = userAllRoomDataModel.get('user_theme')
    userTheme = userThemeList[0]
    $(@el).append(@template(user_theme:userTheme))


  #--------------------------
  # set items designs on room
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

  showProfile: ->
    alert('hi')
    console.log("ShowProfileView fun")


