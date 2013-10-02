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
      roomState     : "initial" # Who's room are we viewing? PUBLIC, FRIEND, or SELF
      roomUser      : false     # Backbone Model of room user, or false
      roomData      : false     # Backbone Model of room data, or false
      roomDesigns   : []        # Array of item designs, or empty array
      roomTheme     : {}        # Object containing info on room's theme
      signInState   : false     # Boolean: Is the user signed in?
      signInUser    : false     # Backbone Model of signed-in user, or false
      signInData    : false     # Backbone Model of signed-in user's data, or false
      roomHeaderView: null      # A reference to this view
  })
  
  
  
  # Listen to changes of room state
  Mywebroom.State.on("change:roomState", ->
    # We need to wait for the DOM to be ready before doing anything with the elements on the page
    $(document).ready ->
      if Mywebroom.State.get("roomState") is "PUBLIC" then $("#xroom_header_search").hide() else $("#xroom_header_search").show()
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
  
 

