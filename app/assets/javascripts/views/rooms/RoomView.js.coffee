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
    
    # Make the room public to begin with to force the serach box to hid
    # (5) Set roomState
    Mywebroom.State.set("roomState", "PUBLIC")
    
    ###
    FIXME
    ###
    
    
    ###
    (1)   Set roomUser: {id:123, username: "sherrie"}
    (2)   Set roomData
    (2.1) Set roomDesigns
    (2.2) Set roomTheme
    (3)   Set signInState: true, false
    (4)   Set signInUser: {id:123, username: "bob"}
    (5)   Set roomState: SELF, PUBLIC, FRIEND
    (6)   Set signInData
    ###
    
    # (1) Set roomUser
    roomUsers = new Mywebroom.Collections.ShowRoomUserCollection()
    roomUsers.fetch
      async  : false
      success: ->
        roomUser = roomUsers.first()
        Mywebroom.State.set("roomUser", roomUser)
        
        # Fetch the data associated with this user
        dataCollection = new Mywebroom.Collections.ShowRoomByUserIdCollection()
        dataCollection.fetch
          async  : false
          url    : dataCollection.url Mywebroom.State.get("roomUser").get("id")
          success: ->

            # Extract the first model
            data = dataCollection.first()
            #console.log 'room data from room View: '
            #console.log data        
            # (2) Set roomData
            Mywebroom.State.set("roomData", data)
            
            # (2.1) Set roomDesigns
            Mywebroom.State.set("roomDesigns", data.get("user_items_designs"))
            
            # (2.2) Set roomTheme
            Mywebroom.State.set("roomTheme", data.get("user_theme")[0])

            # (2.3) Set roomItems
            tempItemsCollection = new Backbone.Collection(data.get("user_items"))
            Mywebroom.State.set("roomItems", tempItemsCollection)
            console.log("RoomItems: ")
            console.log(Mywebroom.State.get('roomItems'))
    
    
    
    # Fetch the collection containing the signInUser model
    signInUsers = new Mywebroom.Collections.ShowSignedUserCollection()
    signInUsers.fetch
      async  : false
      success: ->
        # If it works, we know the user is signed in
        # (3) Set signInState
        Mywebroom.State.set("signInState", true)
       
        # Extract the first model
        signInUser = signInUsers.first()
       
        # (4) Set signInUser
        Mywebroom.State.set("signInUser", signInUser)
        
        
    
    
    
    # roomState is set to PUBLIC by default, so we only need
    # to perform further logic when the user is signed-in
    if Mywebroom.State.get("signInState")
      
      # When roomUser and signInUser are the same, we're on our own page
      if  Mywebroom.State.get("roomUser").get("id") is Mywebroom.State.get("signInUser").get("id")
        # (5) set roomState
        Mywebroom.State.set("roomState", "SELF")
        
        # In this case, we can set signInData to roomData
        # (6) set roomData
        Mywebroom.State.set("signInData", Mywebroom.State.get("roomData"))
      else
        # We're not on our own page, so we've got to check if we're friends with the page owner
        friends = new Mywebroom.Collections.ShowIsMyFriendByUserIdAndFriendIdCollection()
        friends.fetch
          async  : false
          url    : friends.url(Mywebroom.State.get("signInUser").get("id"), Mywebroom.State.get("roomUser").get("id"))
          success: ->
            # We're on a friend's page if the collection isn't empty
            # (6) set roomState
            Mywebroom.State.set("roomState", "FRIEND") if friends.length > 0
        
            # In this case, we need to perform another AJAX request to populate signInData
            dataCollection = new Mywebroom.Collections.ShowRoomByUserIdCollection()
            dataCollection.fetch
              async  : false
              url    : dataCollection.url Mywebroom.State.get("signInUser").get("id")
              success: ->
                # (6) Set roomData
                Mywebroom.State.set("signInData", dataCollection.first())
              
        
    
    
    # Place items in the room
    @setRoom("#xroom_items_0")
    @setRoom("#xroom_items_1")
    @setRoom("#xroom_items_2")
    
    
    ###
    Hide all the elements whose data-room-hide property is yes
    ###
    $("[data-room-hide=yes]").hide()
    
    
    
    
    # Initialize Bookmarks Views
    @setBookmarksRoom()
    
    
    
    
    # Create and render Header View
    roomHeaderView = new Mywebroom.Views.RoomHeaderView()
    $("#xroom_header").append(roomHeaderView.el)
    roomHeaderView.render()
    
    # Save a reference in to the state model
    Mywebroom.State.set("roomHeaderView", roomHeaderView)
    
    
    
    
    # Create and render Save, Cancel, Remove View
    storeMenuSaveCancelRemoveView = new Mywebroom.Views.StoreMenuSaveCancelRemoveView()
    $("#xroom_store_menu_save_cancel_remove").append(storeMenuSaveCancelRemoveView.el)
    $("#xroom_store_menu_save_cancel_remove").hide()
    storeMenuSaveCancelRemoveView.render()
    
    # Save a reference to the state model
    Mywebroom.State.set("storeMenuSaveCancelRemoveView", storeMenuSaveCancelRemoveView)





    # Add Images to the Save, Cancel, Remove View
    storeRemoveButton = $.cloudinary.image "store_remove_button.png",{id: "store_remove_button"}
    $("#xroom_store_remove").prepend(storeRemoveButton)

    storeSaveButton = $.cloudinary.image "store_save_button.png",{id: "store_save_button"}
    $("#xroom_store_save").prepend(storeSaveButton)

    storeCancelButton = $.cloudinary.image "store_cancel_button.png",{id: "store_cancel_button"}
    $("#xroom_store_cancel").prepend(storeCancelButton)

    
    
    
    # Create and render Left Scroller View
    roomScrollLeftView = new Mywebroom.Views.RoomScrollLeftView()
    $("#xroom_scroll_left").append(roomScrollLeftView.el)
    roomScrollLeftView.render()
    
    # Save a reference to the state model
    Mywebroom.State.set("roomScrollLeftView", roomScrollLeftView)
    
    
    
    
    # Create and render Right Scroller View
    roomScrollRightView = new Mywebroom.Views.RoomScrollRightView()
    $("#xroom_scroll_right").append(roomScrollRightView.el)
    roomScrollRightView.render()
    
    # Save a reference to the state model
    Mywebroom.State.set("roomScrollRightView", roomScrollRightView)
    
    
    
    
    # Create and render Browse Mode View
    @browseModeView = new Mywebroom.Views.BrowseModeView()
    $("#xroom_bookmarks_browse_mode").append(@browseModeView.el)
    $("#xroom_bookmarks_browse_mode").hide()
    @browseModeView.render()
    
    # Save a reference to the state model
    Mywebroom.State.set("browseModeView", @browseModeView)
    
    
    
    
    # Center the windows and remove the scroll
    $(window).scrollLeft(0)
    $("body").css("overflow-x", "hidden")
    
    
    
    
    # Set up a listener for the BrowseMode:open event
    Mywebroom.App.vent.on("BrowseMode:open", ((event)->
      @changeBrowseMode(event.model)), self)
    
    
    
    
    # Create and render the Footer View
    roomFooterView = new Mywebroom.Views.RoomFooterView()
    $('#xroom_footer').append(roomFooterView.el)
    roomFooterView.render()
    
    # Save a reference to the state model
    Mywebroom.State.set("roomFooterView", roomFooterView)
    
    
    



    ###
    DEAL WITH URL ENCODED PARAMS
    ###

    ###
    entity_type: BOOKMARK, DESIGN, THEME, BUNDLE, ENTIRE_ROOM <-- i.e. model.get("type")
    entity_id  : e.g. 123 <-- model.get("id")
    came_from  : PUBLIC_SHOP, ?? <-- TODO
    item_id    : e.g. 2 <-- model.get("item_id") <-- should only need for bookmarks
    ###
    entity_type = Mywebroom.Helpers.getParameterByName('entity_type')

    if entity_type

      entity_id = Mywebroom.Helpers.getParameterByName('entity_id')
    
      switch entity_type
        
        when "BOOKMARK"
          
          itemId = Mywebroom.Helpers.getParameterByName('item_id')
          

          if not itemId
            throw new Error("BOOKMARK WITHOUT item_id")


          console.log Mywebroom.Helpers.getItemNameOfItemId(parseInt(itemId))
          
          bookmarksView = new Mywebroom.Views.BookmarksView
            items_name: Mywebroom.Helpers.getItemNameOfItemId(parseInt(itemId))
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

        
        
        
        when "DESIGN"

          # (1) Show Store
          Mywebroom.Helpers.showStore()


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
        



        when "THEME"
          
          # (1) Show Store
          Mywebroom.Helpers.showStore()


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




        when "BUNDLE"
          
          # (1) Show Store
          Mywebroom.Helpers.showStore()


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


        
        
        when "ENTIRE_ROOM"
          
          # (1) Show Store
          Mywebroom.Helpers.showStore()


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




    # Conditionally Show Notification Modal
    Mywebroom.Helpers.showModal()




    # Turn off mousewheel
    Mywebroom.Helpers.turnOffMousewheel()
    
    
    
    # Return the view
    this
    

  
  #--------------------------
  # change browse mode. (Pass a new model to it)
  #--------------------------
  changeBrowseMode:(model)->
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
    Mywebroom.Helpers.hideStore()
    
  
  
  
  
  
  
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
