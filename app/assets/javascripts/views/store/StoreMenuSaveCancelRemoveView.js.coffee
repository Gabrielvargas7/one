###
View that displays the SAVE, CANCEL, REMOVE buttons
###
class Mywebroom.Views.StoreMenuSaveCancelRemoveView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Templeate
  #*******************
  template: JST['store/StoreMenuSaveCancelRemoveTemplate']

  #*******************
  #**** Events
  #*******************

  events: {
    'click #xroom_store_save'  :'clickSave'
    'click #xroom_store_cancel':'clickCancel'
    'click #xroom_store_remove':'clickRemove'
  }
  

  #*******************
  #**** Initialize
  #*******************
  initialize: ->

    #*******************
    #**** Render
    #*******************
  render: ->
    #console.log("store menu save page view: ")
    $(@el).append(@template())
    this




  #*******************
  #**** Functions  -events
  #*******************
  clickSave: (event) ->
    
    event.preventDefault()
    #console.log("click Store Save")
    
    
    
    
    
    

    # Displays save message
    toastr.options = {
      "closeButton":     false
      "debug":           false
      "positionClass":   "toast-bottom-left"
      "onclick":         null
      "showDuration":    "300"
      "hideDuration":    "1000"
      "timeOut":         "2000"
      "extendedTimeOut": "1000"
      "showEasing":      "swing"
      "hideEasing":      "linear"
      "showMethod":      "fadeIn"
      "hideMethod":      "fadeOut"
    }
    
    # Display the Toastr message
    toastr.success("The changes to your room have been saved.")
    
    # Tweak the Toastr message so it display where we want it to
    $('.toast-bottom-left').css({'bottom':'76%', 'left':'7%'})
  







    # Hide the Save, Cancel, Remove View
    $('#xroom_store_menu_save_cancel_remove').hide()
    
    
    
    
    
    

    # Save Theme
    @saveNewTheme()
    
    # Save Designs
    @saveNewItems()
    
  
    
    
    
    
  clickCancel: (event) ->
    
    self = this
    event.preventDefault()
    #console.log("click Store Cancel")
    bootbox.confirm("Are you sure you want to cancel all the changes you made in your room?", (result) ->
      if result
        self.revert()
        
        # Hide the Save, Cancel, Remove View
        $('#xroom_store_menu_save_cancel_remove').hide()
    )
    
    

  
  
  clickRemove: (event) ->
    
    self = this
    event.preventDefault()
    #console.log("click Store Remove")
    bootbox.confirm("Are you sure you want to remove this object?", (result) ->
      if result
        self.removeObject()
        
        # Hide the Save, Cancel, Remove View
        $('#xroom_store_menu_save_cancel_remove').hide()
    )
    
    
    
    
    
    
    
    
  
  
  
  revert: ->
    # Revert designs
    # Capture all the changed elements
    $('[data-design-has-changed=true]')
    
    # And iterate over them
    .each( ->
      # Capture the old id
      id = $(this).attr("data-design-id-client")
      
      # Capture the old src
      src = $(this).attr("data-main-src-server")
      
      # Capture the old hover src
      hoverSrc = $(this).attr("data-hover-src-server")
      
  
      $(this)
      # Replace the changed id
      .attr("data-design-id-server", id)
      
      # Replace the changed source
      .attr("src", src)
      
      # Replace the changed hover src
      .attr("data-hover-src-client", hoverSrc)
      
      # And change the status back to current
      .attr("data-design-has-changed", false)
      
      
      
      # Re-Setup Hovering
      self = this
      $(this).hover (->  $(self).attr("src", hoverSrc)), -> $(self).attr("src", src)
      
      
      
      
      
      # And if the image is hidden, change the src back as well
      if $(this).attr("data-room-hide") is "yes"
      
      
        #console.log("******* attr is hidden ********")
      
      
        # Revert hovering
        $(this).off("mouseenter mouseleave")
      
      
        # Make it grey
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
    
    
        # And now we need replace src with above
        $('[data-room-hide=yes]').each ->
          $(this).attr("src", grey[$(this).attr("data-design-item-id")])
      
      
      
    )
      
      
    # Revert the theme
    # Capture all the changed themes
    $('[data-room_theme=' + "new" + ']')
    
    # And iterate over them
    .each( ->
      # Capture the old src
      src = $(this).attr("data-room-theme-src")
      
      $(this)
      # Replace the changed source
      .attr("src", src)
      
      
      # And change the status back to current
      .attr("data-room_theme", "current")
    )
    
    
    
    
    
    
  
  
  removeObject: ->
    
    userId = Mywebroom.State.get("signInUser").get("id")
    
    # backend
    hide = new Mywebroom.Models.HideUserItemsDesignByUserIdAndItemsDesignIdAndLocationIdModel({_id: userId})
    hide.user_id          = userId
    hide.item_design_id   = Mywebroom.State.get("$activeDesign").attr("data-design-id-client")
    hide.location_id      = Mywebroom.State.get("$activeDesign").attr("data-design-location-id")
    hide.save
      wait: true
    ,
      success: (model, response) ->
        #console.log("REMOVE OBJECT SUCCESS\n", response)
        
      error: (model, response) ->
        console.log("REMOVE OBJECT FAIL\n", response)
    
      
      
    ###
    UPDATE DOM
    ###
    # Change the properties of the design in the DOM
    Mywebroom.State.get("$activeDesign").attr("data-room-hide", "yes")
    
    # Change the hover property
    Mywebroom.State.get("$activeDesign").off("mouseenter mouseleave")
    
    
      
        
     
  
    # Turn the item grey
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
    
    
    # And now we need replace src with above
    $('[data-room-hide=yes]').each ->
      $(this).attr("src", grey[$(this).data("room_item_id")])
    
    
    
    
    
    
    



  
  #*******************
  #**** Functions  -save data
  #*******************
  saveNewTheme: ->
    
    # Check to see if the theme is new
    if $('.current_background').attr("data-room_theme") is "new"
      
      # set the data-theme to current
      $('.current_background').attr("data-room_theme",'current')

      themeId     = $('.current_background').attr("data-room_theme_id")
      sectionId   = $('.current_background').attr("data-room_section_id")
      userId      = Mywebroom.State.get("signInUser").get("id")

      updateTheme = new Mywebroom.Models.UpdateUserThemeByUserIdAndSectionIdModel({new_theme_id: themeId, _id: userId})
      updateTheme.section_id = sectionId
      updateTheme.user_id =    userId
      updateTheme.save
        wait: true
      ,
        success: (model, response) ->
          #console.log("THEME SAVE SUCCESS\n", response)
          
        error: (model, response) ->
          #console.log("THEME SAVE FAIL\n", response)
      
        


  saveNewItems: ->
    
    #console.log("***** Beginning Item Save *****")
  
  
  
    # Save the userId for use later
    userId = Mywebroom.State.get("signInUser").get("id")
  
  
  
    ###
    Number of new things
    ###
    #console.log("I see ", $("[data-design-has-changed=true]").size(), " new designs!")
    
    
  
    ###
    Capture all changed items
    Note: we only need to capture those in 1 div
    ###
    $("#xroom_items_0 [data-design-has-changed=true]").each( ->
      
      self = this
      
            
      ###
      Create some references
      ###
      oldId      = $(this).attr("data-design-id-client")
      newId      = $(this).attr("data-design-id-server")
      locationId = $(this).attr("data-design-location-id")
      oldHide    = $(this).attr("data-room-hide")
      newSrc     = $(this).attr("src")
      newHoverSrc = $(this).attr("data-hover-src-server")
      
      
      
      
      ###
      Change the properties of this design (and its sibling design) in the DOM
      ###
      $("[data-design-id-client=" + oldId + "]")
      .attr("data-design-has-changed", false)
      .attr("data-design-id-client", newId)
      .attr("data-room-hide", "no")
      .attr("data-main-src-server", newSrc)
      .attr("data-hover-src-client", newHoverSrc)
      
      
      
      
      
      ###
      If the object had been hidden, toggle it's hide property
      ###
      if oldHide is "yes"
      
        ###
        First, in the DOM
        ###
        $(self).show()

        ###
        Then, to the server
        ###
        hide = new Mywebroom.Models.HideUserItemsDesignByUserIdAndItemsDesignIdAndLocationIdModel({_id: userId})
        hide.user_id        = userId
        hide.item_design_id = oldId
        hide.location_id    = locationId
        hide.save
          wait: true
        ,
          success: (model, response) ->
            #console.log("TOGGLE DESIGN HIDE SUCCESS\n", model)
          
          error: (model, response) ->
            #console.log("TOGGLE DESIGN HIDE FAIL\n", model)
      
      
      
      
      
      
      
      
          
      ###
      Persist the properties to the server
      ###
      model = new Mywebroom.Models.UpdateUserItemsDesignByUserIdAndItemsDesignIdAndLocationIdModel(
        {
          new_items_design_id: newId
          _id                : userId
        }
      )
    
      model.location_id    = locationId
      model.item_design_id = oldId
      model.user_id        = userId
      model.save
        wait: true
      ,
        success: (model, response) ->
          #console.log("UPDATE DESIGN ID SUCCESS\n", response)
         
  
        error: (model, response) ->
          #console.log("UPDATE DESIGN ID FAIL\n", response)
    )
