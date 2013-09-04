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
  @SIGN_IN  = true
  @NOT_SIGN_IN = false

  #*******************
  #**** Initialize
  #*******************
  initialize: ->


  #*******************
  #**** Render
  #*******************
  render: ->

    #*******************    #
    #    image = $.cloudinary.image 'logo-mywebroom.png',  alt: "Logo"
    #    console.log(image)
    #*******************

    this.FLAGS_MAP = {};

    this.FLAGS_MAP['FLAG_PROFILE'] = Mywebroom.Views.RoomView.PUBLIC_ROOM
    this.FLAGS_MAP['FLAG_SIGN_IN'] = Mywebroom.Views.RoomView.NOT_SIGN_IN



    # get room user
    @userRoomCollection = this.getRoomLoadingUserCollection()
    @userRoomModel = @userRoomCollection.first()

    # get sign in user if exist
    @userSignInCollection = this.getUserSignInCollection()
    @userSignInModel = @userSignInCollection.first()

    if @userRoomModel.id is undefined
      this.forwardToRoot()
    else

      this.FLAGS_MAP['FLAG_PROFILE'] = this.setProfileFlags(@userSignInModel,@userRoomModel)
      this.FLAGS_MAP['FLAG_SIGN_IN'] = this.setSignInFlag(@userSignInModel)


      # get user room data
      @roomUserDataCollection = this.getRoomUserDataCollection(@userRoomModel.get('id'))
      @roomUserDataModel = @roomUserDataCollection.first()

      # get user sign in data
      @signInUserDataCollection = this.getSignInUserDataCollection(@userSignInModel.get('id'))
      @signInUserDataModel = @signInUserDataCollection.first()

      console.log("@roomUserData: ")
      console.log(@roomUserDataModel)

      this.setRoomTheme  @roomUserDataModel
      this.setRoomItemsDesigns(@roomUserDataModel, this.FLAGS_MAP['FLAG_PROFILE'])
      this.setRoomHeader( @roomUserDataModel, @signInUserDataModel, this.FLAGS_MAP)
      this.setStoreMenuSaveCancelRemove()

    this


  #*******************
  #**** Functions  Initialize Room
  #*******************


  #--------------------------
  # set Sign in global variable
  #--------------------------
  setSignInFlag: (userSignInModel) ->
    flagSignIn = Mywebroom.Views.RoomView.NOT_SIGN_IN
    if userSignInModel is undefined
      flagSignIn = Mywebroom.Views.RoomView.NOT_SIGN_IN
    else
      flagSignIn = Mywebroom.Views.RoomView.SIGN_IN

    console.log("flag sign in user: "+flagSignIn)
    return flagSignIn




  #--------------------------
  # set profile global variables
  #--------------------------
  setProfileFlags: (userSignInModel,userRoomModel ) ->

    flagProfile =  Mywebroom.Views.RoomView.PUBLIC_ROOM
    if userSignInModel is undefined
      flagProfile = Mywebroom.Views.RoomView.PUBLIC_ROOM
      console.log("flag public user: "+flagProfile)

    else if userSignInModel.id == userRoomModel.id
      flagProfile = Mywebroom.Views.RoomView.MY_ROOM
      console.log("flag room user: "+flagProfile)

    else
      myfriend = new Mywebroom.Collections.ShowIsMyFriendByUserIdAndFriendIdCollection()
      myfriend.fetch
        url:myfriend.url(userSignInModel.id,userRoomModel.id)
        async:false
        success: (response)->
          console.log("@myfriend: ")
          console.log(response)


      if myfriend.length == 0
        flagProfile = Mywebroom.Views.RoomView.PUBLIC_ROOM
        console.log("flag public user: "+flagProfile)

      else
        flagProfile = Mywebroom.Views.RoomView.MY_FRIEND_ROOM
        console.log("flag friend user: "+flagProfile)

    return flagProfile


  #*******************
  #**** Functions  get Collection data
  #*******************

  #--------------------------
  # get the user of the room that is loading
  #--------------------------
  getRoomLoadingUserCollection: ->
    userRoomCollection = new Mywebroom.Collections.ShowRoomUserCollection()
    userRoomCollection.fetch async: false
    console.log("fetch userRoomCollection: "+JSON.stringify(userRoomCollection.toJSON()))
    return userRoomCollection

  #--------------------------
  # get the sign in user  if exist
  #--------------------------
  getUserSignInCollection: ->
    userSignInCollection = new Mywebroom.Collections.ShowSignedUserCollection()
    userSignInCollection.fetch async: false
    console.log("fetch userSignInCollection: "+JSON.stringify(userSignInCollection.toJSON()))
    return userSignInCollection

  #--------------------------
  # get room user data
  #--------------------------
  getRoomUserDataCollection:(userId) ->
    roomUserDataCollection = new Mywebroom.Collections.ShowRoomByUserIdCollection()
    roomUserDataCollection.fetch
      url:roomUserDataCollection.url userId
      async:false
      success: (response)->
        console.log("@roomUserDataCollection: ")
        console.log(response)
#        console.log("@roomUserDataCollection: "+JSON.stringify(response.toJSON()))

    return roomUserDataCollection


  #--------------------------
  # get room user data
  #--------------------------
  getSignInUserDataCollection:(userId) ->
    signInUserDataCollection = new Mywebroom.Collections.ShowRoomByUserIdCollection()
    signInUserDataCollection.fetch
      url:signInUserDataCollection.url userId
      async:false
      success: (response)->
        console.log("@roomUserDataCollection: ")
        console.log(response)

    return signInUserDataCollection


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
  # set main header menu
  #--------------------------
  setRoomHeader:(roomUserDataModel, signInUserDataModel , FlagsMap) ->
    roomHeaderView = new Mywebroom.Views.RoomHeaderView({model:roomUserDataModel,signInUserDataModel:signInUserDataModel,FLAGS_MAP:FlagsMap})
    $('#xroom_header').append(roomHeaderView.el)
    roomHeaderView.render()

  #--------------------------
  # set store menu for save cancel and remove
  #--------------------------
  setStoreMenuSaveCancelRemove: ->
    storeMenuSaveCancelRemoveView = new Mywebroom.Views.StoreMenuSaveCancelRemoveView()
    $('#xroom_store_menu_save_cancel_remove').append(storeMenuSaveCancelRemoveView.el)
    $('#xroom_store_menu_save_cancel_remove').hide()
    storeMenuSaveCancelRemoveView.render()

    #add the images
    storeRemoveButton = $.cloudinary.image 'store_remove_button.png',{ alt: "store remove button", id: "store_remove_button"}
    $('#xroom_store_remove').prepend(storeRemoveButton)
    storeSaveButton = $.cloudinary.image 'store_save_button.png',{ alt: "store save button", id: "store_save_button"}
    $('#xroom_store_save').prepend(storeSaveButton)
    storeCancelButton = $.cloudinary.image 'store_cancel_button.png',{ alt: "store cancel button", id: "store_cancel_button"}
    $('#xroom_store_cancel').prepend(storeCancelButton)


  #--------------------------
  # set theme on id = #xroom
  #--------------------------
  setRoomTheme: (roomUserDataModel) ->
    userThemeList = roomUserDataModel.get('user_theme')
    userTheme = userThemeList[0]
    $(@el).append(@template(user_theme:userTheme))


  #--------------------------
  # set items designs on id = #xroom_items
  #--------------------------
  setRoomItemsDesigns: (roomUserDataModel,profileFlag) ->
    userItemsDesignsList = roomUserDataModel.get('user_items_designs')
    user = roomUserDataModel.get('user')
    length = userItemsDesignsList.length
    i = 0
    while i < length
      #console.log(userItemsDesignsList[i].id)
      userItemsDesignsView = new Mywebroom.Views.RoomUserItemsDesignsView({user_item_design:userItemsDesignsList[i],user:user})
      $('#xroom_items').append(userItemsDesignsView.el)
      userItemsDesignsView.render()
      i++
      if profileFlag == Mywebroom.Views.RoomView.PUBLIC_ROOM
        userItemsDesignsView.undelegateEvents()



