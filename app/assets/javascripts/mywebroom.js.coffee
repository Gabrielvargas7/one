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
  defaultStateModel = Backbone.Model.extend(
    defaults:
      roomState     : false  # Who's room are we viewing? PUBLIC, FRIEND, or SELF
      roomUser      : false  # Backbone Model of room user, or false
      roomData      : false  # Backbone Model of room data, or false
      signInState   : false  # Boolean: Is the user signed in?
      signInUser    : false  # Backbone Model of signed-in user, or false
      signInData    : false  # Backbone Model of signed-in user's data, or false
      
      roomDesigns   : false  # Array of item designs, or empty array
      roomTheme     : false  # Object containing info on room's theme
      
      initialItems: false # Backbone collection of room items
      
      $activeDesign       : false  # A refernce to the element of the design in focus*
      activeDesignIsHidden: false  # yes or no
      
      roomView                     : false  # A reference to this view
      roomHeaderView               : false  # A reference to this view
      storeLayoutView              : false  # A reference to this view
      storeMenuSaveCancelRemoveView: false  # A reference to this view
      roomScrollerLeftView         : false  # A reference to this view
      roomScrollerRightView        : false  # A reference to this view
      
      roomViewState                     : false # open or closed
      roomHeaderViewState               : false # open or closed
      storeLayoutViewState              : false # open or closed
      
      storeState : false # hidden, collapsed, or shown
      
      saveBarWasVisible                 : false # Lets us know if the save bar was showing when we collapsed the store
      
      storeHelper: false # Store information about the tab or object we're on

      activeSitesMenuView: false #A reference to the Active Sites Menu View.
      searchViewArray:false #A reference to an Array of view on the search

      #An object containing base URLs for the shop.
      shopBaseUrl:
        itemDesign:'http://staging-mywebroom.herokuapp.com/shop/show/items-design/'
        bookmark:'http://mywebroom.com/'
        theme: 'http://mywebroom.com/'
        bundle: 'http://mywebroom.com/'
        entireRoom:'http://mywebroom.com/'
        default: 'http://mywebroom.com/'

    )
  Mywebroom.State = new defaultStateModel
  
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
  

  
  
  
  Mywebroom.Helpers.greyHidden = ->
    
    #console.log("GREY HIDDEN")
    
    # Show the hidden designs
    $("[data-room-hide=yes]").show()
    
    
    grey =
      1 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826528/bed_grey.png"             # Bed
      2 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826555/brid_cage_grey.png"       # Bird Cage
      3 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826571/book_stand_grey.png"      # Book Shelve (sic)
      4 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826593/chair_grey.png"           # Chair
      5 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826708/newspaper_grey.png"       # Newspaper
      6 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826862/world_map_grey.png"       # World Map
      7 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826837/tv_stand_grey.png"        # TV Stand
      8 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826663/file_box_grey.png"        # File Box
      9 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826799/shopping_bag_grey.png"    # Shopping Bag
      10: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826815/social_painting_grey.png" # Social Painting
      11: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826648/encylco_shelf_grey.png"   # Encyclo Shelf
      12: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826687/music_box_grey.png"       # Music Box
      13: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826845/tv_grey.png"              # TV
      14: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826633/desk_grey.png"            # Desk
      15: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826721/night_stand_grey.png"     # Night Stand
      16: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826732/notebook_grey.png"        # Notebook
      17: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826603/computer_grey.png"        # Computer
      18: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826751/phone_grey.png"           # Phone
      19: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826675/lamp_grey.png"            # Lamp
      20: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826768/pinboard_grey.png"        # Pinboard
      21: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826784/portrait_grey.png"        # Portrait
      22: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826826/sports_grey.png"          # Sports
      23: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826616/curtain_grey.png"         # Curtain
      24: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826583/box_grey.png"             # Box
      25: "//upload.wikimedia.org/wikipedia/commons/thumb/1/18/Grey_Square.svg/150px-Grey_Square.svg.png"                     # Games -- FIXME -- not correct image
    
    
    # And now we need to replace src with above
    $('[data-room-hide=yes]').each ->
      $(this).attr("src", grey[$(this).attr("data-design-item-id")])
  
  
  
  
  Mywebroom.Helpers.hideHidden = ->
    
    #console.log("HIDE HIDDEN")
    
    # Show the hidden designs
    $("[data-room-hide=yes]").hide()
  
  
  
  Mywebroom.Helpers.unHighlight = ->
  
    #console.log("UNHIGHLIGHT")
    
    # Revert the highlighting
    $('[data-room-highlighted=true]').each( ->
      $(this)
      .attr("src", $(this).attr("data-main-src-client"))
      .attr("data-room-highlighted", false)
    )
    
    
  
  Mywebroom.Helpers.highLight = (id) ->
    
    Mywebroom.Helpers.unHighlight()
    
    $('[data-design-item-id=' + id + ']').each( ->
      $(this)
      .attr("src", $(this).attr("data-hover-src-client"))
      .attr("data-room-highlighted", true)
      .show()
    )
  
    
    
  Mywebroom.Helpers.turnOnHover = ->
    
    #console.log("TURN ON HOVER")
    
    $('.room_design').each( -> 
      $(this)
      .mouseenter( -> $(this).attr("src", $(this).attr("data-hover-src-client")))
      .mouseleave( -> $(this).attr("src", $(this).attr("data-main-src-client")))
    )
    
    
  Mywebroom.Helpers.turnOffHover = ->
    
    #console.log("TURN OFF HOVER")
    
    $('.room_design').each( ->
      $(this).off("mouseenter mouseleave")
    )
    
    
  
  Mywebroom.Helpers.hideScrollers = ->
    
    #console.log("HIDE SCROLLERS")
    
    $("#xroom_scroll_left").hide()
    $("xroom_scroll_right").hide()
    
  
  Mywebroom.Helpers.showScrollers = ->

    #console.log("SHOW SCROLLERS")
    
    $("#xroom_scroll_left").show()
    $("xroom_scroll_right").show()
 
    
  Mywebroom.Helpers.shrinkStore = ->
          
    #console.log("SHRINK STORE")
    
    $('.store_main_box_right').hide() # Hide the main box
    $('#store_main_box').css('width', '40px')
    $('#store_collapse_img').attr('src','http://res.cloudinary.com/hpdnx5ayv/image/upload/v1375811602/close-arrow_nwupj2.png')
    $('#store_collapse_button img').removeClass('flipimg') # Button now faces the left 
    
    
    
  Mywebroom.Helpers.unShrinkStore = ->
    
    #console.log("UNSHRINK STORE")
    
    $('.store_main_box_right').show() # Un-hide the main box
    
    # Note: this width should be the same as #store_main_box in stylesheets/rooms_store.css.scss
    $('#store_main_box').css('width', '700px')
    
    $('#store_collapse_button img').addClass('flipimg')
    
    
    
  Mywebroom.Helpers.setSaveBarVisibility = ->
    
    #console.log("SET SAVEBAR VISIBILITY")
    
    visible = $('#xroom_store_menu_save_cancel_remove').is(":visible")
    Mywebroom.State.set("saveBarWasVisible", visible)
  
  
  
  
  Mywebroom.Helpers.cancelChanges = ->
    
    #console.log("CANCEL CHANGES")
    
    # CANCEL DESIGNS
    $("[data-design-has-changed=true]").each( ->
        $(this)
        .attr("src", $(this).attr("data-main-src-server"))
        .attr("data-main-src-client",  $(this).attr("data-main-src-server"))
        .attr("data-hover-src-client", $(this).attr("data-hover-src-server"))
        .attr("data-design-id-client", $(this).attr("data-design-id-server"))
        .attr("data-design-has-changed", false)
    )


    # CANCEL THEMES
    $("[data-theme-has-changed=true]").each( ->
        $(this)
        .attr("src", $(this).attr("data-theme-src-server"))
        .attr("data-theme-src-client", $(this).attr("data-theme-src-server"))
        .attr("data-theme-id-client", $(this).attr("data-theme-id-server"))
        .attr("data-theme-has-changed", false)
    )

  
  
  
  
  ###
  (1) Store visibility
  (1.1) Scroller visibility
  (2.1) Get saveBarWasVisible
  (2.2) Set saveBarWasVisible
  (2.3) Save, Cancel, Remove view visibility
  (3) Button visibility <-- don't worry about
  (4) Active Nav Tab
  (5) Search filter
  (6) Dropdown filters
  (7) Hidden item visibility: grey or hidden
  (8) Highlighted Images
  (9) Room size & Button class
  (10) Image Hover: on or off
  (11) Set Store State
  ###
  
 
 
 
  ###
  hidden_to_shown
  ###
  Mywebroom.Helpers.showStore = ->
    #console.log("show store")
    
    # (1) Store visibility
    $('#xroom_storepage').show()
    
    
    # (1.1) Scroller visibility
    $("#xroom_scroll_left").hide()
    $("xroom_scroll_right").hide()
    
    
    # (2.1) Get saveBarWasVisible
    # (2.2) Set saveBarWasVisible
    
    
    # (2.3) Save, Cancel, Remove view visibility
    $('#xroom_store_menu_save_cancel_remove').hide()
    
    
    # (3) Button Visibility
    # n/a
    
    
    # (4) Active Nav Tab
    $('a[href="#tab_items"]').tab('show')
    
    
    # (5) Search filter
    $('#store-search-dropdown li').removeClass('active') # Remove active class
    $("#store-search-all").addClass("active") # Add active class to ALL
    $('#store-dropdown-btn').text("ALL") # Change the text of the search filter to ALL
    
    
    # (6) Dropdown filters
    $('#dropdown-object').removeClass('collapse')
    $('#dropdown-style').removeClass('collapse')
    $('#dropdown-brand').removeClass('collapse')
    $('#dropdown-location').removeClass('collapse')
    $('#dropdown-color').removeClass('collapse')
    $('#dropdown-make').removeClass('collapse')
    
    
    # (7) Hidden item visibility: grey or hidden
    Mywebroom.Helpers.greyHidden()
    
    
    # (8) Highlighted Images
    # n/a
    
    
    # (9) Room size & Button class
    Mywebroom.Helpers.unShrinkStore()
    
    
    # (10) Image Hover: on or off
    Mywebroom.Helpers.turnOffHover()
    
    
    # (11) Set Store State
    Mywebroom.State.set("storeState", "shown")
    
    
  ###
  init_TO_hidden, shown_TO_hidden, collapsed_TO_hidden
  ###
  Mywebroom.Helpers.hideStore = ->
    #console.log("show store")
    
    # (1) Store visibility
    $('#xroom_storepage').hide()
    
    
    # (1.1) Scroller visibility
    $("#xroom_scroll_left").show()
    $("xroom_scroll_right").show()
    
    
    # (2.1) Get saveBarWasVisible
    # (2.2) Set saveBarWasVisible
    
    
    # (2.3) Save, Cancel, Remove view visibility
    $('#xroom_store_menu_save_cancel_remove').hide()
    
    
    # (3) Button Visibility
    # n/a 
    
    
    # (4) Active Nav Tab
    # n/a
    
    
    # (5) Search filter
    # n/a
    
    
    # (6) Dropdown filters
    # n/a
    
    
    # (7) Hidden item visibility: grey or hidden
    Mywebroom.Helpers.hideHidden()
    
    
    # (8) Highlighted Images
    Mywebroom.Helpers.unHighlight()
    
    
    # (9) Room size & Button class
    Mywebroom.Helpers.unShrinkStore()
    
  
    # (10) Image Hover: on or off
    Mywebroom.Helpers.turnOnHover()
    
    
    # (11) Set Store State
    Mywebroom.State.set("storeState", "hidden")
    
    
    
    
  ###
  shown_TO_collapsed
  ###
  Mywebroom.Helpers.collapseStore = ->
    console.log("collapse store")
    
    # (1) Store visibility
    $('#xroom_storepage').show()
    
    
    # (1.1) Scroller visibility
    $("#xroom_scroll_left").show()
    $("xroom_scroll_right").show()
    
    
    # (2.1) Get saveBarWasVisible    
    # (2.2) Set saveBarWasVisible
    Mywebroom.Helpers.setSaveBarVisibility()
    
    
    # (2.3) Save, Cancel, Remove view visibility
    $('#xroom_store_menu_save_cancel_remove').hide()
    
    
    # (3) Button Visibility
    # n/a 
    
    
    # (4) Active Nav Tab
    # n/a
    
    
    # (5) Search filter
    # n/a
    
    
    # (6) Dropdown filters
    # n/a
    
    
    # (7) Hidden item visibility: grey or hidden
    # n/a
    
    
    # (8) Highlighted Images
    # n/a
    
    
    # (9) Room size & Button class
    Mywebroom.Helpers.shrinkStore()
    
    
    # (10) Image Hover: on or off
    # n/a
    
    
    # (11) Set Store State
    Mywebroom.State.set("storeState", "collapsed")
    
    
    
    
  ###
  collapsed_TO_shown
  ###
  Mywebroom.Helpers.expandStore = ->
    console.log("expand store") 
    
    # (1) Store visibility
    $('#xroom_storepage').show()
    
    
    # (1.1) Scroller visibility
    $("#xroom_scroll_left").hide()
    $("xroom_scroll_right").hide()
    
    
    # (2.1) Get saveBarWasVisible
    flag = Mywebroom.State.get("saveBarWasVisible")
    
    
    # (2.2) Set saveBarWasVisible
    
    
    # (2.3) Save, Cancel, Remove view visibility
    if flag is true
      $('#xroom_store_menu_save_cancel_remove').show()
    
    
    # (3) Button Visibility
    # n/a
    
    
    # (4) Active Nav Tab
    # n/a
    
    
    # (5) Search filter
    # n/a
    
    
    # (6) Dropdown filters
    # n/a
    
    
    # (7) Hidden item visibility: grey or hidden
    # n/a
    
    
    # (8) Highlighted Images
    # n/a
    
    
    # (9) Room size & Button class
    Mywebroom.Helpers.unShrinkStore()
    
    
    # (10) Image Hover: on or off
    # n/a
    
    
    # (11) Set Store State
    Mywebroom.State.set("storeState", "shown")
 
    ###
  get Item Name of room object from the item's id. 
  ###
  Mywebroom.Helpers.getItemNameOfItemId =(modelId)->
    #Compare modelToBrowse ID to state room designs items id
    for item in Mywebroom.State.get('roomDesigns')
      if modelId is item.item_id
        return item.items_name
  
 
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
