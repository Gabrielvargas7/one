class Mywebroom.Views.XRoomView extends Backbone.View

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
  events:
    'click #xroom_menu_profile':'homeProfile'


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
#      this.getUserDataCollection()
      this.getUserDataCollection(@userRoomModel.get('id'))
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
#  getUserDataCollection: ->
#    @userAllRoomDataCollection = new Mywebroom.Collections.XRoomsJsonShowRoomByUserIdCollection()
#    console.log("user defined: "+JSON.stringify(@userRoomModel.toJSON()))
#    @userAllRoomDataCollection.user_id = @userRoomModel.get('id')
#    @userAllRoomDataCollection.fetch async: false

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
      userItemsDesignsView = new Mywebroom.Views.RoomUserItemsDesignsView({user_item_design:userItemsDesignsList[i]})
      $('#xroom_items').append(userItemsDesignsView.el)
      userItemsDesignsView.render()
      i++


  #*******************
  #**** Funtions  Profile
  #*******************

  homeProfile: ->
    console.log("Create ProfileView ")
#    userProfileHomeView = new Mywebroom.Views.XProfileHomeView()
#    $('#xroom_profile').append(userProfileHomeView.el)
#    userProfileHomeView.render()



