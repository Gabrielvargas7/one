class Mywebroom.Views.RoomView extends Backbone.Marionette.ItemView

  #*******************
  #**** Template *****
  #*******************
  template: JST["rooms/RoomThemeTemplate"]




  #*******************
  #**** Initialize ***
  #*******************
  initialize: ->





    self = this


    ###
    (0)   Set staticContent
    (1)   Set roomUser: {id:123, username: "sherrie"}
    (2)   Set roomData
    (2.1) Set roomDesigns
    (2.2) Set roomTheme
    (3)   Set signInState: true, false
    (4)   Set signInUser: {id:123, username: "bob"}
    (5)   Set roomState: SELF, PUBLIC, FRIEND
    (6)   Set signInData
    ###


    ###
    DETERMINE IF USER IS IN A ROOM
    ###
    isInARoom = @isInARoom()




    ###
    DETERMINE IF USER IS SIGNED IN
    ###
    isSignedIn = @isSignedIn()




    switch isSignedIn


      when false #CASE: SIGNED OUT


        if isInARoom #...AND IN A ROOM

          roomUser =   @getRoomUser()
          signInUser = false

          Mywebroom.State.set("signInState", false)
          Mywebroom.State.set("signInUser", signInUser)
          Mywebroom.State.set("roomState", "PUBLIC")
          Mywebroom.State.set("roomUser", roomUser)

          @signedOutRoom()




        else #...AND NOT IN A ROOM

          roomUser =   false
          signInUser = false

          Mywebroom.State.set("signInState", false)
          Mywebroom.State.set("signInUser", signInUser)
          Mywebroom.State.set("roomState", "NONE")
          Mywebroom.State.set("roomUser", roomUser)

          @signedOut()






      when true #CASE: SIGNED IN


        if not isInARoom #...AND NOT IN A ROOM

          roomUser =   false
          signInUser = @getSignInUser()

          Mywebroom.State.set("signInState", true)
          Mywebroom.State.set("signInUser", signInUser)
          Mywebroom.State.set("roomState", "NONE")
          Mywebroom.State.set("roomUser", roomUser)

          @signedIn()





        else #...AND IN A ROOM



          roomUser =   @getRoomUser()
          signInUser = @getSignInUser()


          if roomUser.get("id") is signInUser.get("id") # ROOM: SELF


            Mywebroom.State.set("signInState", true)
            Mywebroom.State.set("signInUser", signInUser)
            Mywebroom.State.set("roomState", "SELF")
            Mywebroom.State.set("roomUser", roomUser)

            @signedInSelf()





          else # ROOM: FRIEND OR PUBLIC


            roomUser =   @getRoomUser()
            signInUser = @getSignInUser()



            friends = new Mywebroom.Collections.ShowIsMyFriendByUserIdAndFriendIdCollection()
            friends.fetch
              async: false
              url: friends.url(signInUser.get("id"), roomUser.get("id"))
              success: (collection, response, options) ->
                # console.log("isMyFriend fetch success", response)

              error: (collection, response, options) ->
                console.error("isMyFriend fetch fail", response.responseText)




            if friends.length > 0 # ROOM: FRIEND

              Mywebroom.State.set("signInState", true)
              Mywebroom.State.set("signInUser", signInUser)
              Mywebroom.State.set("roomState", "FRIEND")
              Mywebroom.State.set("roomUser", roomUser)

              @signedInFriend()



            else # ROOM: PUBLIC

              Mywebroom.State.set("signInState", true)
              Mywebroom.State.set("signInUser", signInUser)
              Mywebroom.State.set("roomState", "PUBLIC")
              Mywebroom.State.set("roomUser", roomUser)


              @signedInPublic()



  #--------------------------
  # change browse mode. (Pass a new model to it)
  #--------------------------
  changeBrowseMode: (model) ->

    $("#xroom_bookmarks_browse_mode").show()
    $(".browse_mode_view").show()

    @browseModeView.activeSiteChange(model)





  #--------------------------
  # set room on the rooms.html
  #--------------------------
  setRoom: (xroom_item_num) ->

    $(xroom_item_num).append(@template(theme: Mywebroom.State.get("roomTheme")))


    _.each(Mywebroom.State.get("roomDesigns"), (design) ->

      # (1) Create a proper backbone model out of the design data
      model = new Backbone.Model(design)


      ###
      CREATE DESIGN VIEWS
      ###
      view = new Mywebroom.Views.RoomDesignView({model: model})
      $(xroom_item_num).append(view.el)
      view.render()


      if Mywebroom.State.get("roomState") is "PUBLIC"
        view.undelegateEvents()
    )


    # TRANSITION OUR STORE TO A HIDDEN STATE
    # this also adds the click events for objects
    Mywebroom.Helpers.EditorHelper.hideStore()







  #-------------------------------
  # set bookmarks on the rooms.html
  #-------------------------------
  setBookmarksRoom: ->

    $("#xroom_bookmarks").hide()

    roomUser = Mywebroom.State.get("roomUser")
    designs  = Mywebroom.State.get("roomDesigns")


    length = designs.length
    i = 0


    while i < length
      if designs[i].clickable is "yes"
        bookmarkHomeView = new Mywebroom.Views.BookmarkHomeView(
          {
            user_item_design: designs[i],
            user            : roomUser
          }
        )

        $("#xroom_bookmarks").append(bookmarkHomeView.el)
        bookmarkHomeView.render()


        # Hide the bookmarks
        $("#room_bookmark_item_id_container_" + designs[i].item_id).hide()

      i += 1







  ###
  Determines if user is in a room
  Returns boolean
  ###
  isInARoom: ->

    path = window.location.pathname

    if path.split('/')[1] is 'room' and typeof path.split('/')[2] is "string" and path.split('/')[2].length > 0

      return true

    else

      return false







  ###
  DETERMINE IF USER IS SIGNED IN
  ###
  isSignedIn: ->

    isSignedInModel = new Mywebroom.Models.ShowIsSignedUserModel()
    isSignedInModel.fetch
      async: false
      success: (model, response, options) ->
        # console.log("signedIn fetch success", response)

      error: (model, response, options) ->
        console.error("isSigedIn model fetch fail", response.responseText)


    isSignedIn = isSignedInModel.get('signed')


    switch isSignedIn

      when "yes"
        return true

      when "not"
        return false

      else
        console.error("UNEXPECTED VALUE FOR ShowIsSignedeUserModel", isSignedIn)
        return false








  getRoomUser: ->

    # Set roomUser
    roomUsers = new Mywebroom.Collections.ShowRoomUserCollection()
    roomUsers.fetch
      async  : false
      success: (collection, response, options) ->
        # console.log("roomUser fetch success", response)
      error: (collection, response, options) ->
        console.error("roomUser fetch fail", response.responseText)


    roomUser = roomUsers.first()
    return roomUser





  getSignInUser: ->

    signInUsers = new Mywebroom.Collections.ShowSignedUserCollection()
    signInUsers.fetch
      async: false
      success: (collection, response, options) ->
        # console.log('signedUser collection fetch success', resposne)

      error: (collection, response, options) ->
        console.error('signInUsers collection fetch fail', response.responseText)


    signInUser = signInUsers.first()
    return signInUser





  getRoomData: (userId) ->

    dataCollection = new Mywebroom.Collections.ShowRoomByUserIdCollection()
    dataCollection.fetch
      async: false
      url: dataCollection.url(userId)
      success: (collection, response, options) ->
        # console.log("roomData fetch success", resposne)

      error: (collection, response, options) ->
        console.error("roomData fetch fail", response.responseText)


    dataModel = dataCollection.first()
    return dataModel











  signedOut: ->

    #console.log("SIGNED OUT - NOT IN A ROOM")

    roomState = Mywebroom.State.get("roomState")
    if roomState isnt "NONE" then console.error("ERROR: signedOut.roomState should be NONE but is " + roomState)


    signInState = Mywebroom.State.get("signInState")
    if signInState isnt false then console.error("ERROR: signedOut.signInState should be false but is " + signInState)


    roomUser = Mywebroom.State.get("roomUser")
    if roomUser isnt false then console.error("ERROR: signedOut.roomUser should be false but is " + roomUser)


    signInUser = Mywebroom.State.get("signInUser")
    if signInUser isnt false then console.error("ERROR: signedOut.signInUser should be false but is " + signInUser)




    Mywebroom.State.set("roomData", false)
    Mywebroom.State.set("roomDesigns", false)
    Mywebroom.State.set("roomTheme", false)
    Mywebroom.State.set("roomItems", false)


    Mywebroom.State.set("signInData", false)












  signedOutRoom: ->

    roomState = Mywebroom.State.get("roomState")
    if roomState isnt "PUBLIC" then console.error("ERROR: signedOutRoom.roomState should be PUBLIC but is " + roomState)


    signInState = Mywebroom.State.get("signInState")
    if signInState isnt false then console.error("ERROR: signedOutRoom.signInState should be false but is " + signInState)


    roomUser = Mywebroom.State.get("roomUser")
    if roomUser is false then console.error("ERROR: signedOutRoom.roomUser shouldnt be false but it is")


    signInUser = Mywebroom.State.get("signInUser")
    if signInUser isnt false then console.error("ERROR: signedOutRoom.signInUser should be false but is " + signInUser)



    #console.log("SIGNED OUT - IN " + roomUser.get("username") + "\'s ROOM")




    # roomData
    data = @getRoomData(roomUser.get('id'))
    Mywebroom.State.set("roomData", data)


    # roomDesigns
    designs = data.get('user_items_designs')
    Mywebroom.State.set("roomDesigns", designs)


    # roomTheme
    theme = data.get('user_theme')[0]
    Mywebroom.State.set("roomTheme", theme)


    # roomItems
    items = new Backbone.Collection(data.get("user_items"))
    Mywebroom.State.set("roomItems", items)


    # signInData
    Mywebroom.State.set("signInData", false)


    # (10) Setup Room
    @doRoomStuff()







  signedIn: ->

    #console.log("SIGNED IN - NOT IN ROOM")


    roomState = Mywebroom.State.get("roomState")
    if roomState isnt "NONE" then console.error("ERROR: signedIn.roomState should be NONE but is " + roomState)


    signInState = Mywebroom.State.get("signInState")
    if signInState isnt true then console.error("ERROR: signedIn.signInState should be true but is " + signInState)


    roomUser = Mywebroom.State.get("roomUser")
    if roomUser isnt false then console.error("ERROR: signedIn.roomUser should be false but is " + roomUser)


    signInUser = Mywebroom.State.get("signInUser")
    if signInUser is false then console.error("ERROR: signedIn.signInUser shouldnt be false but it is")




    Mywebroom.State.set("roomData", false)
    Mywebroom.State.set("roomDesigns", false)
    Mywebroom.State.set("roomTheme", false)
    Mywebroom.State.set("roomItems", false)


    data = @getRoomData(signInUser.get('id'))
    Mywebroom.State.set("signInData", data)










  signedInPublic: ->

    roomState = Mywebroom.State.get("roomState")
    if roomState isnt "PUBLIC" then console.error("ERROR: signedInPublic.roomState should be PUBLIC but is " + roomState)


    signInState = Mywebroom.State.get("signInState")
    if signInState isnt true then console.error("ERROR: signedInPublic.signInState should be true but is " + signInState)


    roomUser = Mywebroom.State.get("roomUser")
    if roomUser is false then console.error("ERROR: signedInPublic.roomUser shouldnt be false but it is")


    signInUser = Mywebroom.State.get("signInUser")
    if signInUser is false then console.error("ERROR: signedInPublic.signInUser shouldnt be false but it is")


    if roomUser.get("id") is signInUser.get("id") then console.error("ERROR: signedInPublic.signInUser.id equals signedInPublic.roomUser.id but shouldnt")




    #console.log("SIGNED IN - IN " + roomUser.get("username") + "\'s ROOM (public)")





    data = @getRoomData(roomUser.get('id'))
    Mywebroom.State.set("roomData", data)


    designs = data.get('user_items_designs')
    Mywebroom.State.set("roomDesigns", designs)


    theme = data.get('user_theme')[0]
    Mywebroom.State.set("roomTheme", theme)


    items = new Backbone.Collection(data.get("user_items"))
    Mywebroom.State.set("roomItems", items)




    signInData = @getRoomData(signInUser.get('id'))
    Mywebroom.State.set("signInData", signInData)




    # Setup Room
    @doRoomStuff()











  signedInFriend: ->

    roomState = Mywebroom.State.get("roomState")
    if roomState isnt "FRIEND" then console.error("ERROR: signedInFriend.roomState should be FRIEND but is " + roomState)


    signInState = Mywebroom.State.get("signInState")
    if signInState isnt true then console.error("ERROR: signedInFriend.signInState should be true but is " + signInState)


    roomUser = Mywebroom.State.get("roomUser")
    if roomUser is false then console.error("ERROR: signedInFriend.roomUser shouldnt be false but it is")


    signInUser = Mywebroom.State.get("signInUser")
    if signInUser is false then console.error("ERROR: signedInFriend.signInUser shouldnt be false but it is")


    if roomUser.get("id") is signInUser.get("id") then console.error("ERROR: signedInFriend.signInUser.id equals signedInFriend.roomUser.id but shouldnt")




    #console.log("SIGNED IN - IN " + roomUser.get("username") + "\'s ROOM (friend)")




    data = @getRoomData(roomUser.get('id'))
    Mywebroom.State.set("roomData", data)


    designs = data.get('user_items_designs')
    Mywebroom.State.set("roomDesigns", designs)


    theme = data.get('user_theme')[0]
    Mywebroom.State.set("roomTheme", theme)


    items = new Backbone.Collection(data.get("user_items"))
    Mywebroom.State.set("roomItems", items)




    signInData = @getRoomData(signInUser.get('id'))
    Mywebroom.State.set("signInData", signInData)




    # Setup Room
    @doRoomStuff()










  signedInSelf: ->


    roomState = Mywebroom.State.get("roomState")
    if roomState isnt "SELF" then console.error("ERROR: signedInSelf.roomState should be SELF but is " + roomState)


    signInState = Mywebroom.State.get("signInState")
    if signInState isnt true then console.error("ERROR: signedInSelf.signInState should be true but is " + signInState)


    roomUser = Mywebroom.State.get("roomUser")
    if roomUser is false then console.error("ERROR: signedInSelf.roomUser shouldnt be false but it is")


    signInUser = Mywebroom.State.get("signInUser")
    if signInUser is false then console.error("ERROR: signedInSelf.signInUser shouldnt be false but it is")


    if roomUser.get("id") isnt signInUser.get("id") then console.error("ERROR: signedInSelf.signInUser.id doesnt equal signedInSelf.roomUser.id but it should")




    #console.log("SIGNED IN - IN " + roomUser.get("username") + "\'s ROOM (self)")




    data = @getRoomData(roomUser.get('id'))
    Mywebroom.State.set("roomData", data)


    designs = data.get('user_items_designs')
    Mywebroom.State.set("roomDesigns", designs)


    theme = data.get('user_theme')[0]
    Mywebroom.State.set("roomTheme", theme)


    items = new Backbone.Collection(data.get("user_items"))
    Mywebroom.State.set("roomItems", items)





    Mywebroom.State.set("signInData", data)




    # Setup Room
    @doRoomStuff()









    user_profile = Mywebroom.State.get("signInData").get("user_profile")


    if user_profile.tutorial_step == 0

      # (16) Conditionally Show Notification Modal
      Mywebroom.Helpers.AppHelper.showModal()


      ###
       (11) DEAL WITH URL ENCODED PARAMS WHEN the user is Sign in his/her Room State
      ###
      ###
            entity_type: BOOKMARK, DESIGN, THEME, BUNDLE, ENTIRE_ROOM <-- i.e. model.get("type")
            entity_id  : e.g. 123 <-- model.get("id")
            came_from  : PUBLIC_SHOP, ?? <-- TODO
            item_id    : e.g. 2 <-- model.get("item_id") <-- should only need for bookmarks
      ###

      entity_type = Mywebroom.Helpers.AppHelper.getParameterByName('entity_type')
      came_from = Mywebroom.Helpers.AppHelper.getParameterByName('came_from')

      #Friends has no parameter: came_from
      #The only things that have Came_from are SHOP and EMAIL.
      #Test for CAME_FROM Email case. Then test entity_type.

      if came_from

        switch came_from

          when "EMAIL_REQUEST_KEY"
            #console.log("Profile Request Accept entity")
            @entityTypeRequest()

          when "PUBLIC_SHOP", "FRIEND_ROOM", "PUBLIC_ROOM"

            if entity_type

              entity_id = Mywebroom.Helpers.AppHelper.getParameterByName('entity_id')

              switch entity_type

                when "BOOKMARK"
                  #console.log("bookmark entity ")
                  @entityTypeBookmark(entity_id)

                when "DESIGN"
                  #console.log("designs entity ")
                  @entityTypeItemDesign(entity_id)

                when "THEME"
                  #console.log("theme entity ")
                  @entityTypeTheme(entity_id)

                when "BUNDLE"
                  #console.log("Bundle entity ")
                  @entityTypeBundle(entity_id)

                when "ENTIRE_ROOM"
                  #console.log("Entire room entity")
                  @entityTypeEntireRoom(entity_id)


    else

      @doTutorialStuff()












  doRoomStuff: ->




    #console.log("SETTING UP ROOM")



    ###
    SETUP STEPS FOR BOTH SIGNED IN
    AND NON-SIGNED IN USERS
    ###


    # (2) Place items in the room
    @setRoom("#xroom_items_0")
    @setRoom("#xroom_items_1")
    @setRoom("#xroom_items_2")







    ###
    (3) Hide all the elements whose data-room-hide property is yes
    ###
    $("[data-room-hide=yes]").hide()









    # (4) Initialize Bookmarks Views
    @setBookmarksRoom()










    # (5) Create and render Left Scroller View
    roomScrollLeftView = new Mywebroom.Views.RoomScrollLeftView()
    $("#xroom_scroll_left").append(roomScrollLeftView.el)
    roomScrollLeftView.render()

    # Save a reference to the state model
    Mywebroom.State.set("roomScrollLeftView", roomScrollLeftView)








    # (6) Create and render Right Scroller View
    roomScrollRightView = new Mywebroom.Views.RoomScrollRightView()
    $("#xroom_scroll_right").append(roomScrollRightView.el)
    roomScrollRightView.render()

    # Save a reference to the state model
    Mywebroom.State.set("roomScrollRightView", roomScrollRightView)







    # (7) Create and render Browse Mode View
    @browseModeView = new Mywebroom.Views.BrowseModeView()
    $("#xroom_bookmarks_browse_mode").append(@browseModeView.el)
    $("#xroom_bookmarks_browse_mode").hide()
    @browseModeView.render()

    # Save a reference to the state model
    Mywebroom.State.set("browseModeView", @browseModeView)








    # (8) Center the windows and remove the scroll
    $(window).scrollLeft(0)
    $("body").css("overflow-x", "hidden")








    # (9) Set up a listener for the BrowseMode:open event
    that = this
    Mywebroom.App.vent.on("BrowseMode:open", ((that) ->
      Mywebroom.State.get('roomView').changeBrowseMode(that.model)), self)









    # (10) Create and render the Footer View
    roomFooterView = new Mywebroom.Views.RoomFooterView()
    $('#xroom_footer').append(roomFooterView.el)
    roomFooterView.render()

    # Save a reference to the state model
    Mywebroom.State.set("roomFooterView", roomFooterView)





    # (11) Turn off mousewheel
    Mywebroom.Helpers.AppHelper.turnOffMousewheel()






    # (12) Listen for editor scroll
    Mywebroom.Helpers.EditorHelper.onEditorScroll()





    # (13) Create and render Header View
    roomHeaderView = new Mywebroom.Views.RoomHeaderView()
    $("#xroom_header").append(roomHeaderView.el)
    roomHeaderView.render()


    # (13.1) Create Search Box
    searchView = new Mywebroom.Views.SearchView()
    searchView.render()

    $("#xroom_header_search_box").append(searchView.el)
    $("#xroom_header_search_box").hide()


    # Save a ref to the state model
    Mywebroom.State.set("roomHeaderView", roomHeaderView)







    # (14) Create and render Save, Cancel, Remove View
    storeMenuSaveCancelRemoveView = new Mywebroom.Views.StoreMenuSaveCancelRemoveView()
    $("#xroom_store_menu_save_cancel_remove").append(storeMenuSaveCancelRemoveView.el)
    $("#xroom_store_menu_save_cancel_remove").hide()
    storeMenuSaveCancelRemoveView.render()

    # Save a reference to the state model
    Mywebroom.State.set("storeMenuSaveCancelRemoveView", storeMenuSaveCancelRemoveView)







    # (15) Add Images to the Save, Cancel, Remove View
    storeRemoveButton = $.cloudinary.image "store_remove_button.png",{id: "store_remove_button"}
    $("#xroom_store_remove").prepend(storeRemoveButton)

    storeSaveButton = $.cloudinary.image "store_save_button.png",{id: "store_save_button"}
    $("#xroom_store_save").prepend(storeSaveButton)

    storeCancelButton = $.cloudinary.image "store_cancel_button.png",{id: "store_cancel_button"}
    $("#xroom_store_cancel").prepend(storeCancelButton)
































  doTutorialStuff: ->

    view = new Mywebroom.Views.TutorialWelcomeView()
    $("#xroom_tutorial_container").append(view.el)
    view.render()










  ##########################
  #  DEAL WITH URL ENCODED PARAMS
  ##########################

  # ENCODED PARAMS Bookmarks
  entityTypeBookmark: (entity_id) ->

    itemId = Mywebroom.Helpers.AppHelper.getParameterByName('item_id')


    if not itemId
      throw new Error("BOOKMARK WITHOUT item_id")


    #console.log Mywebroom.Helpers.AppHelper.getItemNameOfItemId(parseInt(itemId))


    bookmarksView = new Mywebroom.Views.BookmarksView
      items_name: Mywebroom.Helpers.AppHelper.getItemNameOfItemId(parseInt(itemId))
      item_id: itemId
      user: Mywebroom.State.get("roomUser").get("id")


    $('#room_bookmark_item_id_container_' + itemId).append(bookmarksView.el)
    bookmarksView.render()

    $('#room_bookmark_item_id_container_' + itemId).show()
    $('#xroom_bookmarks').show()


    # TODO Check for bookmark in my bookmarks
    if !bookmarksView.collection.findWhere(id: parseInt(entity_id))
      bookmarksView.renderDiscover()
      bookmarksView.highlightItem(entity_id)
    else
      # we're already on MyBookmarks so don't bookmarksView.renderMyBookmarks()
      bookmarksView.highlightItem(entity_id)









  # ENCODED PARAMS Item design
  entityTypeItemDesign: (entity_id) ->
    #console.log("designs entity ")

    # (1) Show Store
    Mywebroom.Helpers.EditorHelper.showStore()


    # (2) Switch to the hidden tab
    $('#storeTabs a[href="#tab_hidden"]').tab('show')


    # (3) Fetch the corresponding model
    model = new Mywebroom.Models.ShowItemDesignByIdModel({id: entity_id})
    model.fetch
      async: false
      success: (model, response, options) ->
        #console.log("model fetch success", response)
      error: (model, response, options) ->
        console.error("model fetch fail", response.responseText)



    # (4) Use model to populate view
    Mywebroom.State.get("storeMenuView").appendOne(model)








  # ENCODED PARAMS theme
  entityTypeTheme: (entity_id) ->
    #console.log("theme entity ")

    # (1) Show Store
    Mywebroom.Helpers.EditorHelper.showStore()


    # (2) Switch to the hidden tab
    $('#storeTabs a[href="#tab_hidden"]').tab('show')


    # (3) Fetch the corresponding model
    model = new Mywebroom.Models.ShowThemeByIdModel({id: entity_id})
    model.fetch
      async: false
      success: (model, response, options) ->
        #console.log("model fetch success")
        error: (model, response, options) ->
          console.error("model fetch fail", response.responseText)


    # (4) Use model to populate view
    Mywebroom.State.get("storeMenuView").appendOne(model)








  # ENCODED PARAMS Bundle
  entityTypeBundle: (entity_id) ->
    # (1) Show Store
    Mywebroom.Helpers.EditorHelper.showStore()


    # (2) Switch to the hidden tab
    $('#storeTabs a[href="#tab_hidden"]').tab('show')


    # (3) Fetch the corresponding model
    model = new Mywebroom.Models.ShowBundleByIdModel({id: entity_id})
    model.fetch
      async: false
      success: (model, response, options) ->
        #console.log("model fetch success")
        error: (model, response, options) ->
          console.error("model fetch fail", response.responseText)


    # (4) Use model to populate view
    Mywebroom.State.get("storeMenuView").appendOne(model)









  entityTypeEntireRoom: (entity_id) ->

    # (1) Show Store
    Mywebroom.Helpers.EditorHelper.showStore()


    # (2) Switch to the hidden tab
    $('#storeTabs a[href="#tab_hidden"]').tab('show')


    # (3) Fetch the corresponding model
    model = new Mywebroom.Models.ShowEntireRoomByIdModel({id: entity_id})
    model.fetch
      async: false
      success: (model, response, options) ->
        #console.log("model fetch success")
        error: (model, response, options) ->
          console.error("model fetch fail", response.responseText)


    # (4) Use model to populate view
    Mywebroom.State.get("storeMenuView").appendOne(model)






  entityTypeRequest: ->

    #Show Profile Requests Page.

    #1. Grab Profile View reference
    profileView = Mywebroom.State.get('profileHomeView')

    #2. Show Requests Page.
    profileView.showProfileKeyRequests() if profileView

    #displayProfile
    Mywebroom.State.get('roomHeaderView').displayProfile()
