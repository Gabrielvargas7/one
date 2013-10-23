window.Mywebroom =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Helpers:{}
  State:{}
  Data:{}
  App:{}


$(document).ready ->
  
  # Define the state model
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
  
  # Create the state model
  Mywebroom.State = new defaultStateModel()
  
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
      
      roomState = Mywebroom.State.get("roomState")
      
      if roomState is "PUBLIC" then $("#xroom_header_search").hide() else $("#xroom_header_search").show()  
  )
  



  ###
  STATIC DATA
  ###
  Mywebroom.Data = {
      ItemModels: {} # format -> 2: Backbone.Model
      ItemNames:  {} # format -> 3: "string"
      ItemIds:    Object.create(null) # *see below # format -> 7: true
  }
 
  
  ###
  *To create a true set [http://en.wikipedia.org/wiki/Set_(mathematics)], 
  we want an object that doesn't already have any properties on it. 
  
  http://stackoverflow.com/questions/7958292/mimicking-sets-in-javascript
  http://www.devthought.com/2012/01/18/an-object-is-not-a-hash/
  
  Since this program speaks coffee, we use "of" to query instead of "in".
  
  http://stackoverflow.com/questions/6408726/iterate-over-associative-array-in-coffeescript/6408784#6408784
  ###
  
  


  
  Mywebroom.Helpers.showModal = ->
    ###
    MODAL
    ###
    
    # ID
    id = Mywebroom.State.get("signInUser").get("id")
    
    
    # NOTIFICATION
    model = new Mywebroom.Models.ShowUserNotificationByIdModel({id: id})
    model.fetch
      async: false
      success: (response) ->
        console.log("notification model fetched", response)
        
        # View
        view = new Mywebroom.Views.InsView({model: model})
    
    
        # Modal
        modal = new Backbone.BootstrapModal({content: view}).open()
        
        
        
        
        ###
        LET THE SERVER KNOW WE DON'T NEED THIS NOTIFICATION AGAIN - START
        ###
        user_id = Mywebroom.State.get("signInUser").get("id")
    
        note = new Mywebroom.Models.UpdateUserNotificationToNotifiedByUserModel({_id: user_id})
        note.user_id = user_id
        note.save
          wait: true
        ,
          success: (model, response) ->
            console.log("REMOVE NOTIFICATION SUCCESS\n", response)
        
          error: (model, response) ->
            console.log("REMOVE NOTIFICATION FAIL\n", response)
        ###
        LET THE SERVER KNOW WE DON'T NEED THIS NOTIFICATION AGAIN - END
        ###
        
        
        
      
      error: (response) ->
        console.log("notification model fail", response)
        
        
    
  
  Mywebroom.Helpers.setCategories = (categories) ->
    
    # empty out existing dropdown items
    $('#dropdown-category > .dropdown-menu').empty()
  
  
    # iterate through the category items and create a li out of each one
    _.each(categories, (category) ->
      if category.category
        $('#dropdown-category > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(category.category) + '</a></li>')
    )
  
  

  
  Mywebroom.Helpers.setBrands = (brands) ->
    
    # empty out existing dropdown items
    $('#dropdown-brand > .dropdown-menu').empty()
    
    
    # iterate through the brand items and create a li out of each one
    _.each(brands, (brand) ->
      if brand.brand
        $('#dropdown-brand > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(brand.brand) + '</a></li>')
    )
  
  
  
  
  Mywebroom.Helpers.setLocations = (locations) ->
    
    # empty out existing dropdown items
    $('#dropdown-location > .dropdown-menu').empty()
    
    
    # iterate through the location items and create a li out of each one
    _.each(locations, (location) ->
      if location.location
        $('#dropdown-location > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(location.location) + '</a></li>')
    )
  
  Mywebroom.Helpers.setStyles = (styles) ->
    # empty out existing dropdown items
    $('#dropdown-style > .dropdown-menu').empty()
    
    
    # iterate through the style items and create a li out of each one
    _.each(styles, (style) ->
      if style.style
        $('#dropdown-style > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(style.style) + '</a></li>')
    )
  
  
  
  
  Mywebroom.Helpers.setColors = (colors) ->
    
    # empty out existing dropdown items
    $('#dropdown-color > .dropdown-menu').empty()
    
    
    # iterate through the color items and create a li out of each one
    _.each(colors, (color) ->
      if color.color
        $('#dropdown-color > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(color.color) + '</a></li>')
    )
  
   
  
  Mywebroom.Helpers.setMakes = (makes) ->
    
    # empty out existing dropdown items
    $('#dropdown-make > .dropdown-menu').empty()
    
    
    # iterate through the make items and create a li out of each one
    _.each(makes, (make) ->
      if make.make
        $('#dropdown-make > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(make.make) + '</a></li>')
    )
  
  
  Mywebroom.Helpers.collapseFilters = ->
    
    # Add the collapse class
    $('#dropdown-category').addClass('collapse')
    $('#dropdown-style').addClass('collapse')
    $('#dropdown-brand').addClass('collapse')
    $('#dropdown-location').addClass('collapse')
    $('#dropdown-color').addClass('collapse')
    $('#dropdown-make').addClass('collapse')
    
  Mywebroom.Helpers.expandFilters = ->
   
    # Remove the collapse class
    $('#dropdown-category').removeClass('collapse')
    $('#dropdown-style').removeClass('collapse')
    $('#dropdown-brand').removeClass('collapse')
    $('#dropdown-location').removeClass('collapse')
    $('#dropdown-color').removeClass('collapse')
    $('#dropdown-make').removeClass('collapse')
  
  
  
  
  Mywebroom.Helpers.greyHidden = ->
    
    #console.log("GREY HIDDEN")
    
    # Show the hidden designs
    $("[data-room-hide=yes]").show()
    
    
    # And now we need to replace src with above
    $('[data-room-hide=yes]').each ->
      
      
      # Look up the grey object on the corresponding item
      grey = Mywebroom.Data.ItemModels[Number($(this).data().designItemId)].get("image_name_grey")
      
    
      # Check to see if the grey link has been added
      if typeof grey isnt "object"
        url = "/assets/fallback/item/default_item.png"
      else
        url = grey.url
        
      
  
      $(this).attr("src", url)
  
  
  
  
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

  
  
  
  
  
  
  Mywebroom.Helpers.turnOnDesignClick = ->
    
    user_id = Mywebroom.State.get("roomUser").get("id")
    
    $('img.room_design').each( ->
      
      $(this).off('click') # So we don't have multiple click handlers
      
      $(this).click( ->
        
        # item_id extracted from the clicked element
        dom_item_id = $(this).data().designItemId
        
        
        # model associated with this item_id
        model = Mywebroom.Data.ItemModels[dom_item_id]
        
        
        ###
        Close all bookmark containers except this item's
        ###
        for key of Mywebroom.Data.ItemIds
          el = $('#room_bookmark_item_id_container_' + key)
          if dom_item_id.toString() is key.toString() then el.show() else el.hide()
        
    
        ###
        Show / Hide various divs
        ###
        $('#xroom_store_menu_save_cancel_remove').hide()
        $('#xroom_storepage').hide()
        $('#xroom_profile').hide()
        $('#xroom_bookmarks').show()
   
    
        ###
        Create bookmark view
        ###
        if model.get("clickable") is "yes"
          view = new Mywebroom.Views.BookmarksView(
            {
              items_name:       model.get("items_name")
              user_item_design: model.get("item_id")
              user:             user_id
            }
          )
      
          $('#room_bookmark_item_id_container_' + dom_item_id).append(view.el)
          view.render()
      )
    )
    
    
  Mywebroom.Helpers.turnOffDesignClick = ->
    
    $('img.room_design').off('click')
  
  
  
  
  Mywebroom.Helpers.centerItem = (item_id) ->
    

    # Look up the item model
    model = Mywebroom.Data.ItemModels[item_id]

           
    ###
    BASED ON X and Y COORDINATES
    ###
    item_location_x = parseInt(model.get('x'))
    item_location_y = parseInt(model.get('y'))
    
   
    #console.log('item location y', item_location_y)
    
    $('#xroom_items_0').attr('data-current_screen_position','0')
    $('#xroom_items_0').css({
      'left': Math.floor(-1999 - item_location_x + 100)
    })
    
    #console.log('room top', $('#xroom_items_0').css('top'))
    #console.log('room bottom', $('#xroom_items_0').css('bottom'))
    
    $('#xroom_items_1').attr('data-current_screen_position','1')
    $('#xroom_items_1').css({
      'left': Math.floor(0 - item_location_x + 100)
    })
    
    $('#xroom_items_2').attr('data-current_screen_position','2')
    $('#xroom_items_2').css({
      'left': Math.floor(1999 - item_location_x + 100)
    })
    
    
    ###
    ScrollTo Y Value - 100
    ###
    $.scrollTo(item_location_y - 100, {axis: 'y'})
    
  Mywebroom.Helpers.updateRoomDesign = (model) ->
    
    console.log("updateRoomDesign")
  
    ###
    DESIGN TYPE
    ###
    design_type = model.get("item_id")
  
  
    ###
    NEW PROPERTIES
    ###
    new_design_id = model.get("id")
    new_main_src =  model.get("image_name").url
    new_hover_src = model.get("image_name_hover").url
    
    
    
    
    ###
    CURRENT ITEM
    ###
    current_design = $('[data-design-item-id=' + design_type + ']')
    
    
    
    
    ###
    OLD PROPERTIES
    ###
    old_design_id = current_design.attr("data-design-id-server")
    old_main_src =  current_design.attr("data-main-src-server")
    old_hover_src = current_design.attr("data-hover-src-server")
    
    
    
    
    ###
    UPDATE DOM PROPERTIES
    ###
    current_design
    .attr("src", new_hover_src)
    .attr("data-design-id-client", new_design_id)
    .attr("data-main-src-client", new_main_src)
    .attr("data-hover-src-client", new_hover_src)
    .attr("data-room-highlighted", true)
    
    
    
    
    
    ###
    CHECK IF DESIGN IS NEW
    ###
    if old_design_id.toString() isnt new_design_id.toString() or old_main_src.toString() isnt new_main_src.toString() or old_hover_src.toString() isnt new_hover_src.toString()
      
      # Design is changed
      current_design.attr("data-design-has-changed", true)
      
      # Show the save button
      $('#xroom_store_save').show()
    
      # Show the cancel button
      $('#xroom_store_cancel').show()
    
      # Show the remove button unless the current design is hidden
      unless current_design.attr("data-room-hide") is "yes"
        $('#xroom_store_remove').show()
    
    else
      
      # Design is un-changed
      current_design.attr("data-design-has-changed", false)
    
    
    
    
 

      
      
  
  
  
  
  Mywebroom.Helpers.updateRoomTheme = (model) ->
    
    console.log("updateRoomTheme")    
    
    ###
    NEW PROPERTIES
    ###
    new_url =      model.get('image_name').url
    new_theme_id = model.get('id')
    
    
    
    
    ###
    CURRENT THEME
    ###
    current_theme = $('.current_background')
    
    
    
    
    ###
    OLD PROPERTIES
    ###
    old_url =      current_theme.attr("data-theme-src-server")
    old_theme_id = current_theme.attr("data-theme-id-server") 
    
    
    
    
    ###
    UPDATE DOM PROPERTIES
    ###
    current_theme
    .attr("src", new_url)
    .attr("data-theme-id-client", new_theme_id)
    .attr("data-theme-src-client", new_url)
    
    
    
    
    ###
    CHECK IF THEME IS NEW
    ###
    if old_url.toString() isnt new_url.toString() or old_theme_id.toString() isnt new_theme_id.toString()
      
      # Theme has changed
      current_theme.attr("data-theme-has-changed", true)
    
      # SET STATE OF SAVE, CANCEL, REMOVE BUTTONS
      # Show the save button
      $('#xroom_store_save').show()
    
      # Show the cancel button
      $('#xroom_store_cancel').show()
    
      # Hide the remove button
      $('#xroom_store_remove').hide()
    
    else
      
      # Theme is un-changed
      current_theme.attr("data-theme-has-changed", false)
    
    
    
    
    
    
      
  


  
  Mywebroom.Helpers.showSaveBar = ->
    
    if $('[data-design-has-changed=true]').size() > 0 or $('[data-theme-has-changed=true]').size() > 0
      
      # Show the Save Bar
      $("#xroom_store_menu_save_cancel_remove").show()
      
    else 
      
      # Hide the Save Bar
      $("#xroom_store_menu_save_cancel_remove").hide()
  
  
  
  
  Mywebroom.Helpers.turnOffMousewheel = ->
    $('#xroom').on('mousewheel', (e) ->
        e.preventDefault()
        e.stopPropagation()
        #console.log("no mousewheel")
    )
    
    
  Mywebroom.Helpers.turnOnMousewheel = ->
    $('#xroom').off('mousewheel')
  
  
  Mywebroom.Helpers.getSEOLink = (id, type) ->
     
    ###
    TYPES: ENTIRE_ROOM, BUNDLE, THEME, BOOKMARK, DESIGN
    ###
    model = new Mywebroom.Models.ShowSeoLinkByIdModel({id: id, type: type})
    model.fetch
      async: false
      success: (model, response, options) ->
        #console.log("model fetch success", model, response, options)
      error: (model, response, options) ->
        console.log("model fetch fail", model, response, options)
    
    
    return model
    
  
  Mywebroom.Helpers.setItemRefs = ->
    
    items = Mywebroom.State.get("initialItems")
    
    
    items.each( (item) ->
      
      
      # (1) Create a (unique) set of the item id's
      id = item.get("id")
      Mywebroom.Data.ItemIds[id] = true
      
    
      # (2) Store a reference to the item models based on id
      Mywebroom.Data.ItemModels[id] = item
      
     
      # (3) Assocaiate item names with item ids
      name = item.get("name")
      Mywebroom.Data.ItemNames[id] = name
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
  (10.1) Image Click: on or off
  (11) Mousewheel 
  (12) Set Store State
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
    
    
    # (10.1) Image Click: on or off
    Mywebroom.Helpers.turnOffDesignClick()
    
    
    # (11) Mousewheel
    Mywebroom.Helpers.turnOffMousewheel()
    
    
    # (12) Set Store State
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
    
    
    # (10.1) Image Click: on or off
    Mywebroom.Helpers.turnOnDesignClick()
    
    
    # (11) Mousewheel
    Mywebroom.Helpers.turnOnMousewheel()
    
    
    # (12) Set Store State
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
    
    
    # (10.1) Image Click: on or off
    # n/a
    
    
    # (11) Mousewheel
    # n/a
    
    
    # (12) Set Store State
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
    
    
    # (10.1) Image Click: on or off
    # n/a
    
    
    # (11) Mousewheel
    # n/a
    
    
    # (12) Set Store State
    Mywebroom.State.set("storeState", "shown")
 
    ###
  get Item Name of room object from the item's id. 
  ###
  Mywebroom.Helpers.getItemNameOfItemId = (modelId) ->
    
    # Compare modelToBrowse ID to state room designs items id
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
