class Mywebroom.Views.RoomView extends Backbone.Marionette.ItemView

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Templeate
  #*******************

  template: JST['rooms/RoomTemplate']


  #*******************
  #**** Events
  #*******************



  #*******************
  #**** GLOBAL VARIBLES
  #*******************
  @MY_ROOM = "MY_ROOM"
  @MY_FRIEND_ROOM = 'MY_FRIEND_ROOM'
  @PUBLIC_ROOM = 'PUBLIC_ROOM'
  @SIGN_IN  = true
  @NOT_SIGN_IN = false

  #*******************
  #**** Initialize ***
  #*******************
  initialize: ->
    this.FLAGS_MAP = {};

    this.FLAGS_MAP['FLAG_PROFILE'] = Mywebroom.Views.RoomView.PUBLIC_ROOM
    this.FLAGS_MAP['FLAG_SIGN_IN'] = Mywebroom.Views.RoomView.NOT_SIGN_IN



    # get room user
    @userRoomCollection = this.getRoomLoadingUserCollection()
    @userRoomModel = @userRoomCollection.first()

    # get sign in user if exist
    @mainUserCollection = this.getUserSignInCollection()
    if @mainUserCollection is undefined
       @signInUser = false
       console.log("sign in false")

       @mainUserModel = @userRoomCollection.first()
    else
       @mainUserModel = @mainUserCollection.first()
       @signInUser = true
       console.log("sign in true")




    if @userRoomModel.id is undefined
      this.forwardToRoot()
    else

      this.FLAGS_MAP['FLAG_PROFILE'] = this.setProfileFlags(@signInUser,@mainUserModel,@userRoomModel)
      this.FLAGS_MAP['FLAG_SIGN_IN'] = this.setSignInFlag(@signInUser)


      # get user room data
      @roomUserDataCollection = this.getRoomUserDataCollection(@userRoomModel.get('id'))
      @roomUserDataModel = @roomUserDataCollection.first()

      # get user sign in data
      @mainUserDataCollection = this.getSignInUserDataCollection(@mainUserModel.get('id'))
      @mainUserDataModel = @mainUserDataCollection.first()

      console.log("@roomUserData: ")
      console.log(@roomUserDataModel)

      # this.setRoomTheme  @roomUserDataModel
      this.setRoomItemsDesigns(@roomUserDataModel, this.FLAGS_MAP['FLAG_PROFILE'])
      this.setRoomHeader( @roomUserDataModel, @mainUserDataModel, this.FLAGS_MAP)
      this.setStoreMenuSaveCancelRemove(@mainUserDataModel)
      this.setRoomScrolls(@roomUserDataModel)
      this.setBrowseMode()

      # center the windows  and remove the scroll
      $(window).scrollLeft(2300)
      $('body').css('overflow-x', 'hidden');

      this.setEventTest()
      this.setBrowseModeEvents()


    this

    



  #*******************
  #**** Functions  set Variables
  #*******************

  #--------------------------
  # set Sign in global variable
  #--------------------------
  setSignInFlag: (signInUser) ->
    flagSignIn = Mywebroom.Views.RoomView.NOT_SIGN_IN

    if signInUser  == true
      flagSignIn = Mywebroom.Views.RoomView.SIGN_IN
    else
      flagSignIn = Mywebroom.Views.RoomView.NOT_SIGN_IN

    console.log("flag sign in user: "+flagSignIn)

    return flagSignIn


  #--------------------------
  # set profile global variables
  #--------------------------
  setProfileFlags: (signInUser,mainUserModel,userRoomModel) ->

    flagProfile =  Mywebroom.Views.RoomView.PUBLIC_ROOM
    if signInUser == false
      flagProfile = Mywebroom.Views.RoomView.PUBLIC_ROOM
      console.log("flag public user: "+flagProfile)

    else if mainUserModel.id == userRoomModel.id
      flagProfile = Mywebroom.Views.RoomView.MY_ROOM
      console.log("flag room user: "+flagProfile)

    else
      myfriend = new Mywebroom.Collections.ShowIsMyFriendByUserIdAndFriendIdCollection()
      myfriend.fetch
        url:myfriend.url(mainUserModel.id,userRoomModel.id)
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
    userSignInCollection.fetch
      async:false
      success: (response)->
        console.log("fetch userSignInCollection: "+userSignInCollection)
        console.log(response)
      error: ->
        userSignInCollection = undefined
        console.log("error fetch userSignInCollection "+userSignInCollection)
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
  setStoreMenuSaveCancelRemove:(signInUserDataModel) ->
    storeMenuSaveCancelRemoveView = new Mywebroom.Views.StoreMenuSaveCancelRemoveView({signInUserDataModel:signInUserDataModel})
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
  # set browse mode 
  #--------------------------
  setBrowseMode:->
    @browseModeView = new Mywebroom.Views.BrowseModeView()
    $('#xroom_bookmarks_browse_mode').append(@browseModeView.el)
    $('#xroom_bookmarks_browse_mode').hide()
    @browseModeView.render()
  #--------------------------
  # change browse mode. (Pass a new model to it)
  #--------------------------
  changeBrowseMode:(model)->
    console.log('now we play with BrowseMode for reals!')
    $('#xroom_bookmarks_browse_mode').show()
    $('.browse_mode_view').show()
    @browseModeView.activeSiteChange(model)
    console.log(@browseModeView)



  #--------------------------
  # set arrow for left and right scroll
  #--------------------------

  setRoomScrolls: (roomUserDataModel)->
    userItemsDesignsList = roomUserDataModel.get('user_items_designs')
    roomScrollLeftView = new Mywebroom.Views.RoomScrollLeftView({user_items_designs:userItemsDesignsList})
    $('#xroom_scroll_left').append(roomScrollLeftView.el)
    roomScrollLeftView.render()

    roomScrollRightView = new Mywebroom.Views.RoomScrollRightView({user_items_designs:userItemsDesignsList})
    $('#xroom_scroll_right').append(roomScrollRightView.el)
    roomScrollRightView.render()



  #--------------------------
  # set items designs and themes
  #--------------------------
  setRoomItemsDesigns: (roomUserDataModel,profileFlag) ->
    this.setRoom('#xroom_items_0',roomUserDataModel,profileFlag)
    this.setRoom('#xroom_items_1',roomUserDataModel,profileFlag)
    this.setRoom('#xroom_items_2',roomUserDataModel,profileFlag)
    this.setBookmarksRoom(roomUserDataModel,profileFlag)


  #--------------------------
  # set room on the rooms.html
  #--------------------------
  setRoom: (xroom_item_num,roomUserDataModel,profileFlag) ->

    console.log(xroom_item_num,roomUserDataModel,profileFlag)

    userItemsDesignsList = roomUserDataModel.get('user_items_designs')
    user = roomUserDataModel.get('user')

    userThemeList = roomUserDataModel.get('user_theme')
    userTheme = userThemeList[0]
    $(xroom_item_num).append(@template(user_theme:userTheme))

    length = userItemsDesignsList.length
    i = 0
    while i < length
      userItemsDesignsView = new Mywebroom.Views.RoomUserItemsDesignsView({user_item_design:userItemsDesignsList[i],user:user,user_items_designs_list:userItemsDesignsList})
      $(xroom_item_num).append(userItemsDesignsView.el)
      userItemsDesignsView.render()

      if profileFlag == Mywebroom.Views.RoomView.PUBLIC_ROOM
        userItemsDesignsView.undelegateEvents()
      i++


  #--------------------------
  # set bookmarks on the rooms.html
  #--------------------------
  setBookmarksRoom: (roomUserDataModel,profileFlag) ->

    $('#xroom_bookmarks').hide()

    console.log(roomUserDataModel,profileFlag)

    userItemsDesignsList = roomUserDataModel.get('user_items_designs')
    user = roomUserDataModel.get('user')

    length = userItemsDesignsList.length
    i = 0

    while i < length
      if userItemsDesignsList[i].clickable == 'yes'
        bookmarkHomeView = new Mywebroom.Views.BookmarkHomeView({user_item_design:userItemsDesignsList[i],user:user})
        $('#xroom_bookmarks').append(bookmarkHomeView.el)
        bookmarkHomeView.render()
        $('#room_bookmark_item_id_container_'+userItemsDesignsList[i].item_id).hide()
      i++


  setEventTest:->
    console.log("add global event")
    Mywebroom.App.vent.on("some:event",->
      console.log("in global event")
      alert "some event was fired!"
    )
  setBrowseModeEvents:->
    self = this
    Mywebroom.App.vent.on("BrowseMode:open",((event)->
      @changeBrowseMode(event.model)),self)
