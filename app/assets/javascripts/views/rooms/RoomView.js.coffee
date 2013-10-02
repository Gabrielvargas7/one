class Mywebroom.Views.RoomView extends Backbone.Marionette.ItemView

  #*******************
  #**** Template *****
  #*******************
  template: JST["rooms/RoomTemplate"]



  #*******************
  #**** Initialize ***
  #*******************
  initialize: ->
    self = @
    
    # Make the room public to begin with to force the serach box to hid
    # (5) Set roomState
    Mywebroom.State.set("roomState", "PUBLIC")
    
    
    ###
    (1)   Set roomUser
    (2)   Set roomData
    (2.1) Set roomDesigns
    (2.2) Set roomTheme
    (3)   Set signInState
    (4)   Set signInUser
    (5)   Set roomState
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
        
            # (2) Set roomData
            Mywebroom.State.set("roomData", data)
            
            # (2.1) Set roomDesigns
            Mywebroom.State.set("roomDesigns", data.get("user_items_designs"))
            
            # (2.2) Set roomTheme
            Mywebroom.State.set("roomTheme", data.get("user_theme")[0])
    
    
    
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
          url    : friends.url(Mywebroom.State.get("roomUser").get("id"), Mywebroom.State.get("signInUser").get("id"))
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
    
    
    
    
    # Initialize Bookmarks Views
    @setBookmarksRoom()
    
    
    
    
    # Create and render Header View
    roomHeaderView = new Mywebroom.Views.RoomHeaderView()
    $("#xroom_header").append(roomHeaderView.el)
    roomHeaderView.render()
    Mywebroom.State.set("roomHeaderView", roomHeaderView)
    
    
    
    
    # Create and render Save, Cancel, Remove View
    storeMenuSaveCancelRemoveView = new Mywebroom.Views.StoreMenuSaveCancelRemoveView()
    $("#xroom_store_menu_save_cancel_remove").append(storeMenuSaveCancelRemoveView.el)
    $("#xroom_store_menu_save_cancel_remove").hide()
    storeMenuSaveCancelRemoveView.render()
    
    
    
    
    # Add Images to the Save, Cancel, Remove View
    storeRemoveButton = $.cloudinary.image "store_remove_button.png",{ alt: "store remove button", id: "store_remove_button"}
    $("#xroom_store_remove").prepend(storeRemoveButton)
    storeSaveButton = $.cloudinary.image "store_save_button.png",{ alt: "store save button", id: "store_save_button"}
    $("#xroom_store_save").prepend(storeSaveButton)
    storeCancelButton = $.cloudinary.image "store_cancel_button.png",{ alt: "store cancel button", id: "store_cancel_button"}
    $("#xroom_store_cancel").prepend(storeCancelButton)
    
    
    
    
    # Create and render Left Scroller View
    roomScrollLeftView = new Mywebroom.Views.RoomScrollLeftView()
    $("#xroom_scroll_left").append(roomScrollLeftView.el)
    roomScrollLeftView.render()
    
    
    
    
    # Create and render Right Scroller View
    roomScrollRightView = new Mywebroom.Views.RoomScrollRightView()
    $("#xroom_scroll_right").append(roomScrollRightView.el)
    roomScrollRightView.render()
    
    
    
    
    # Create and render Browse Mode View
    @browseModeView = new Mywebroom.Views.BrowseModeView()
    $("#xroom_bookmarks_browse_mode").append(@browseModeView.el)
    $("#xroom_bookmarks_browse_mode").hide()
    @browseModeView.render()
    
    
    
    
    # Center the windows and remove the scroll
    $(window).scrollLeft(0)
    $("body").css("overflow-x", "hidden");
    
    
    
    
    # Set up a listener for the BrowseMode:open event
    Mywebroom.App.vent.on("BrowseMode:open", ((event)->
      @changeBrowseMode(event.model)), self)
    
    
    
    
    # Create and render the Footer View
    roomFooterView = new Mywebroom.Views.RoomFooterView()
    $('#xroom_footer').append(roomFooterView.el)
    roomFooterView.render()
    
    
    
    
    # Return the view
    @
    

  
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
    
    $(xroom_item_num).append(@template(user_theme: Mywebroom.State.get("roomTheme")))
    
    
    _.each(Mywebroom.State.get("roomDesigns"), (design)->  
      view = new Mywebroom.Views.RoomUserItemsDesignsView({design: design})
      $(xroom_item_num).append(view.el)
      view.render()
      view.undelegateEvents() if Mywebroom.State.get("roomState") is "PUBLIC"
    )
    
    
    
    ###
    Hide all the elements whose data-room-hide property is yes
    ###
    $("[data-room-hide=yes]").hide()
  
  
  
  
    
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
        
        $("#room_bookmark_item_id_container_" + designs[i].item_id).hide()
        
      i++
