window.Mywebroom =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Helpers:{}
  State:{}
  App:{}


$(document).ready ->
  # Create the state model
  Mywebroom.State = new Backbone.Model({
    defaults:
      roomState     : false     # Who's room are we viewing? PUBLIC, FRIEND, or SELF
      roomUser      : false     # Backbone Model of room user, or false
      roomData      : false     # Backbone Model of room data, or false
      roomDesigns   : false     # Array of item designs, or empty array
      roomTheme     : false     # Object containing info on room's theme
      signInState   : false     # Boolean: Is the user signed in?
      signInUser    : false     # Backbone Model of signed-in user, or false
      signInData    : false     # Backbone Model of signed-in user's data, or false
      $activeDesign : false     # A refernce to the element of the design in focus*
      roomView      : false     # A reference to this view
      roomHeaderView: false     # A reference to this view
      storeMenuSaveCancelRemoveView: false  # A reference to this view
      storeMenuSaveCancelRemoveViewState: false # open or closed
      roomScrollLeftView : false  # A reference to this view
      roomScrollRightView: false  # A reference to this view
      browseModeView     : false  # A reference to this view
      roomFooterView     : false  # A reference to this view
  })
  
  ###
  *At the present, this gets set when either the object this design
   belongs to is clicked from the store, or a new design was
   chosen from the store. Would probably be good to have this
   get set when a room design is click directly.
  ###
  
  
  # Listen to changes of room state
  Mywebroom.State.on("change:roomState", ->
    # We need to wait for the DOM to be ready before doing anything with the elements on the page
    $(document).ready ->
      if Mywebroom.State.get("roomState") is "PUBLIC" then $("#xroom_header_search").hide() else $("#xroom_header_search").show()
  )
  
  
  
  # Listen to changes of storeMenuSaveCancelRemoveViewState
  Mywebroom.State.on("change:storeMenuSaveCancelRemoveViewState", ->
    state = Mywebroom.State.get("storeMenuSaveCancelRemoveViewState")
    switch state
      when "open"
        $("#xroom_menu_save_cancel_remove").show()
      when "closed"
        $("#xroom_menu_save_cancel_remove").hide()
  )
  
  
  
  
  
  
  
  
  # Create the Marionette App Object
  Mywebroom.App = new Backbone.Marionette.Application()
  
  # Create Regions
  Mywebroom.App.addRegions
    xroom_main_container               : "#xroom_main_container"
    xroom_scroll_left                  : "#xroom_scroll_left"
    xroom_store_menu_save_cancel_remove: "#xroom_store_menu_save_cancel_remove"
    xroom_profile                      : "#xroom_profile"
    xroom_storepage                    : "#xroom_storepage"
    xroom_bookmarks                    : "#xroom_bookmarks"
    xroom_bookmarks_browse_mode        : "#xroom_bookmarks_browse_mode"
    xroom_footer                       : "#xroom_footer"
    xroom_scroll_right                 : "#xroom_scroll_right"
    xroom                              : "#xroom"
    xroom_items_0                      : "#xroom_items_0"
    xroom_items_1                      : "#xroom_items_1"
    xroom_itmes_2                      : "#xroom_items_2"
    xroom_header                       : "#xroom_header"

    
  
  Mywebroom.App.addInitializer ->
    new Mywebroom.Routers.RoomsRouter()
    Backbone.history.start() if Backbone.history
    
    
  Mywebroom.App.start()
  
 

