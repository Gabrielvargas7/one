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

  }
  #*******************
  #**** GLOBAL VARIBLES
  #*******************
  @MY_ROOM = "MY_ROOM"
  @MY_FRIEND_ROOM = 'MY_FRIEND_ROOM'
  @PUBLIC_ROOM = 'PUBLIC_ROOM'




  #*******************
  #**** Initialize
  #*******************
  initialize: ->



    this.getRoomLoadingUserCollection()
    this.getUserSignInCollection()
#    this.removeRoomClass()

  #*******************
  #**** Render
  #*******************
  render: ->
    this.FLAG_PROFILE = Mywebroom.Views.RoomView.MY_ROOM
    console.log("flag: "+this.FRAG_PROFILE)

    @userRoomModel = @userRoomCollection.first() #username and id
    @userSignIn = @userSignInCollection.first() #username and id

    if @userRoomModel.id is undefined
      this.forwardToRoot()
    else

      this.setFlags()

      this.getUserDataCollection(@userRoomModel.get('id'))
      @userAllRoomDataModel = @userAllRoomDataCollection.first() #user data
      console.log("userAllRoomDataModel: ")
      console.log(@userAllRoomDataModel)

      this.setRoomTheme @userAllRoomDataModel
      this.setRoomItemsDesigns @userAllRoomDataModel
      this.setRoomHeader @userAllRoomDataModel

    this


  #*******************
  #**** Functions  Initialize Room
  #*******************
  setFlags: ->
    if @userSignIn is undefined
      console.log("flag public user: ")
      this.FLAG_PROFILE = Mywebroom.Views.RoomView.PUBLIC_ROOM
    else if @userSignIn.id == @userRoomModel.id
      console.log("flag room user: ")
      this.FLAG_PROFILE = Mywebroom.Views.RoomView.MY_ROOM
    else
      console.log("flag friend user: ")
      this.FLAG_PROFILE = Mywebroom.Views.RoomView.MY_FRIEND_ROOM


  #*******************
  #**** Functions  Initialize Room
  #*******************

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



  #*******************
  #**** Functions  Forward to root
  #*******************

  #--------------------------
  # forward to the origin url if the user does't exist -> ex: 'http://www.mywebroom.com/'
  #--------------------------
  forwardToRoot: ->
    origin = window.location.origin
    console.log("forward to: "+origin)
    window.location.replace(origin)


  #*******************
  #**** Functions  Set RoomViews
  #*******************


  #--------------------------
  # set items designs on id = #xroom_items
  #--------------------------
  setRoomHeader:(userAllRoomDataModel) ->
    roomHeaderView = new Mywebroom.Views.RoomHeaderView({model:userAllRoomDataModel,FLAG_PROFILE:@FLAG_PROFILE})
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
    user = userAllRoomDataModel.get('user')
    length = userItemsDesignsList.length
    i = 0
    while i < length
      #console.log(userItemsDesignsList[i].id)
      userItemsDesignsView = new Mywebroom.Views.RoomUserItemsDesignsView({user_item_design:userItemsDesignsList[i],user:user})
      $('#xroom_items').append(userItemsDesignsView.el)
      userItemsDesignsView.render()
      i++
