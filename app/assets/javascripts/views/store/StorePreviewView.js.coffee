class Mywebroom.Views.StorePreviewView  extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************
  tagName: 'li'
  
  
  #*******************
  #**** Template
  #*******************
  template: JST['store/StorePreviewTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    
    'click .store_container_ITEM':             'clickItem'
    'click .store_container_DESIGN':           'clickDesign'
    'click .store_container_THEME':            'clickTheme'
    'click .store_container_BUNDLE':           'clickBundle'
    'click .store_container_ENTIRE_ROOM':      'clickEntireRoom'
    
    'mouseenter .store_container':       'hoverOn'
    'mouseleave .store_container':       'hoverOff' 
  }
   

  




  #*******************
  #**** Initialize
  #*******************
  initialize: ->

    @button_preview = $.cloudinary.image('button_preview.png', {alt: "button preview", id: "button_preview"})
    @type = @model.get("type")
    
    
  #*******************
  #**** Render
  #*******************
  render: ->

    obj =  @model.clone()
    
    # We set image_name to the matching preview url (when necessary)
    switch @type
      when "ITEM" then false
        # NO CHANGE
      when "DESIGN"
        obj.set("image_name", obj.get("image_name_selection"))
      when "THEME"
        obj.set("image_name", obj.get("image_name_selection"))
      when "BUNDLE" then false
        # NO CHANGE
      when "ENTIRE_ROOM"
        obj.set("image_name", obj.get("image_name_set"))


    $(@el).append(@template(model: obj))
    this

  #*******************
  #**** Funtions  -- Collecton
  #*******************





  #--------------------------
  # get items deisgns of the bundle
  #--------------------------
  getBundleItemDesignsCollection:(bundleId) ->
    bundleItemsDesignsCollection = new Mywebroom.Collections.IndexItemsDesignsOfBundleByBundleIdCollection()
    bundleItemsDesignsCollection.fetch
      async:   false
      url:     bundleItemsDesignsCollection.url(bundleId)
      success: (response) ->
        #console.log("@bundleItemsDesignsCollection: ")
        #console.log(response)

    return bundleItemsDesignsCollection


  #--------------------------
  # get theme of the bundle
  #--------------------------
  getBundleThemeCollection:(themeId) ->
    bundleThemeCollection = new Mywebroom.Collections.ShowThemeByThemeIdCollection()
    bundleThemeCollection.fetch
      async:   false
      url:     bundleThemeCollection.url(themeId)
      success: (response) ->
        #console.log("bundleTheme: ")
        #console.log(response)

    return bundleThemeCollection


  #*******************
  #**** Funtions  -- events
  #*******************





  #--------------------------
  # do something on click
  #--------------------------
  clickEntireRoom: (e) ->
    
    e.preventDefault()
    
    
    self = this
    
    
    #console.log("\n\n\nENTIRE ROOMS clicked\n\n\n")
    
    
    
    # Show the view with the Save, Cancel, Remove view
    $('#xroom_store_menu_save_cancel_remove').show()
    
    
    # SET STATE OF SAVE, CANCEL, REMOVE BUTTONS
    # Show the save button
    $('#xroom_store_save').show()
    
    # Show the cancel button
    $('#xroom_store_cancel').show()
    
    # Hide the remove button
    $('#xroom_store_remove').hide()


    # set the new theme
    bundleThemeCollection = @getBundleThemeCollection(self.model.get('theme_id'))
    bundleThemeModel = bundleThemeCollection.first()
    $('.current_background').attr("src", bundleThemeModel.get('image_name').url);
    $('.current_background').attr("data-room_theme_id", bundleThemeModel.get('id'));
    $('.current_background').attr("data-room_theme",'new');


    # set the new items
    bundleItemsDesignsCollection = @getBundleItemDesignsCollection(self.model.get('id'))
    bundleItemsDesignsCollection.each (entry) ->
      itemId =         entry.get('item_id')
      itemDesignId =   entry.get('id')
      imageName =      entry.get('image_name').url
      imageNameHover = entry.get('image_name_hover').url

      $('[data-design-item-id=' + itemId + ']').attr("src", imageName)
      $('[data-design-item-id=' + itemId + ']').attr("data-design-id-server", itemDesignId)
      $('[data-design-item-id=' + itemId + ']').hover (->  $(self).attr("src", imageNameHover)), -> $(self).attr("src", imageName)
      $('[data-design-item-id=' + itemId + ']').attr("data-design-has-changed", true)






  #--------------------------
  # change all items of the room for bundle when click
  #--------------------------
  clickBundle: (e) ->
    e.preventDefault()
    #console.log("click Store Bundle View " + @model.get('id'))
    
    # Show the view with the Save, Cancel, Remove buttons
    $('#xroom_store_menu_save_cancel_remove').show()
    
    
    # SET STATE OF SAVE, CANCEL, REMOVE BUTTONS
    # Show the save button
    $('#xroom_store_save').show()
    
    # Show the cancel button
    $('#xroom_store_cancel').show()
    
    # Hide the remove button
    $('#xroom_store_remove').hide()
    
    
    bundleItemsDesignsCollection = this.getBundleItemDesignsCollection(@model.get('id'))

    bundleItemsDesignsCollection.each (entry)  ->
      itemId = entry.get('item_id')
      itemDesignId = entry.get('id')
      imageName = entry.get('image_name').url
      imageNameHover = entry.get('image_name_hover').url

      $('[data-design-item-id=' + itemId + ']').attr("src", imageName)
      $('[data-design-item-id=' + itemId + ']').attr("data-design-id-server",itemDesignId)
      $('[data-design-item-id=' + itemId + ']').hover (->  $(this).attr("src",imageNameHover)), -> $(this).attr("src",imageName)
      $('[data-design-item-id=' + itemId + ']').attr("data-design-has-changed", true)







  #--------------------------
  # do something on click
  #--------------------------
  clickTheme: (e) ->
    
    e.preventDefault()
    imageName = @model.get('image_name').url
    
    #console.log("click Store Menu Theme View", @model.get('id'))
    #console.log(imageName)
    
    
    # Show the view with the Save, Cancel, Remove buttons
    $('#xroom_store_menu_save_cancel_remove').show()
    
    
    # SET STATE OF SAVE, CANCEL, REMOVE BUTTONS
    # Show the save button
    $('#xroom_store_save').show()
    
    # Show the cancel button
    $('#xroom_store_cancel').show()
    
    # Hide the remove button
    $('#xroom_store_remove').hide()
    
    
    
    $('.current_background').attr("src", imageName);
    $('.current_background').attr("data-room_theme_id", @model.get('id'));
    $('.current_background').attr("data-room_theme", 'new');





  #--------------------------
  # do something on click
  #--------------------------
  clickDesign: (e) ->
     
    e.preventDefault()
    
    itemId =       @model.get("item_id") # <-- type of design
    itemDesignId = @model.get("id") 
    url =          @model.get("image_name").url         # <-- new one
    urlHover =     @model.get("image_name_hover").url   # <-- new one
  
    
    #console.log("***** CLICK STORE ITEM DESIGN:\t", itemDesignId, " *********")
    
    
    
    
    
    
    ###
    CENTER
    ###
    items = Mywebroom.State.get("initialItems")
    
    
    # Get item that matches this design's item_id
    item = items.findWhere({"id":itemId})
    
    
    # Center
    @setItemToCenter(item)
    
    
    
    ###
    SAVE, CANCEL, REMOVE
    ###
    # Show the Save, Cancel, Remove view
    $("#xroom_store_menu_save_cancel_remove").show()
    
    # Show the save button
    $('#xroom_store_save').show()
    
    # Show the cancel button
    $('#xroom_store_cancel').show()
    
    # Show the remove button unless the current design is hidden
    unless $("[data-design-item-id=" + itemId + "]").attr("data-room-hide") is "yes"
      $('#xroom_store_remove').show()
    
    
    # Change the properties of the design in the DOM
    $('[data-design-item-id=' + itemId + ']').attr("src", url)
    $('[data-design-item-id=' + itemId + ']').attr("data-hover-src-client", urlHover)
    $('[data-design-item-id=' + itemId + ']').attr("data-design-id-server", itemDesignId)
    $('[data-design-item-id=' + itemId + ']').attr("data-design-has-changed", true)
    $('[data-design-item-id=' + itemId + ']').hover (->  $(this).attr("src", urlHover)), -> $(this).attr("src", url)


    ###
    Find the design that was clicked and
    create a reference to it's container element
    ###
    $activeDesign = $("[data-design-item-id=" + itemId + "]")
    

    # Save this object to our state model
    Mywebroom.State.set("$activeDesign", $activeDesign)
    
        
        
    # Is this a hidden object?
    activeDesignIsHidden = $activeDesign.data().roomHide
    Mywebroom.State.set("activeDesignIsHidden", activeDesignIsHidden)
    
    
    # Show
    $activeDesign.show()
    
    
    

    # Highlight
    @highlight(@model)
    
 
 
 
 
  #--------------------------
  # do something on click
  #--------------------------
  clickItem: (e) ->
   
   
    e.preventDefault()
    #console.log("item model", @model)
   
   
   
    
    # Switch to the hidden tab
    $('#storeTabs a[href="#tab_hidden"]').tab('show');
    
    
    

       
    self   = this
    itemId = @model.get("id")
   
   
   
    ###
    Set our store helper
    ###
    Mywebroom.State.set("storeHelper", itemId)
   
   
   
    ###
    Find the design that was clicked and
    create a reference to it's container element
    ###
    $activeDesign = $("[data-design-item-id=" + itemId + "]")
   
   
    # Save this object to our state model
    Mywebroom.State.set("$activeDesign", $activeDesign)
   
   
   
   
    # Show the Save, Cancel, Remove view and remove button
    # iff the object design's roomHide property is "no"
    if $activeDesign.attr("data-room-hide")  is "no"
      # Show the Save, Cancel, Remove view
      $("#xroom_store_menu_save_cancel_remove").show()
   
   
      # SET STATE OF SAVE, CANCEL, REMOVE BUTTONS
      # Hide the save button
      $('#xroom_store_save').hide()
   
      # Hide the cancel button
      $('#xroom_store_cancel').hide()
     
      # Show the remove button
      $('#xroom_store_remove').show()
    else
      # Show the Save, Cancel, Remove view
      $("#xroom_store_menu_save_cancel_remove").hide()
   
   
      # SET STATE OF SAVE, CANCEL, REMOVE BUTTONS
      # Hide the save button
      $('#xroom_store_save').hide()
   
      # Hide the cancel button
      $('#xroom_store_cancel').hide()
     
      # Hide the remove button
      $('#xroom_store_remove').hide()
     
   
   

    # Fetch designs that correspond to items
    itemsDesignsCollection = @getItemsDesignsCollection(itemId)
    
    # Splat to room
    @appendHidden(itemsDesignsCollection)
    
    # Center Item
    @setItemToCenter(@model)
    
    
    
    
    ###
    Highlight Image
    ###
    @highlight(@model)
    
    
    
    
    
    ###
    FILTERS
    ###
    # Show all the dropdown filters
    @expandAll()
   
   
    # Collapse location filter
    $('#dropdown-location').addClass('collapse')
   
   
    # Populate the filters
    categories = new Mywebroom.Collections.IndexItemsDesignsCategoriesByItemIdCollection()
    categories.fetch
      async  : false
      url    : categories.url itemId
      success: (response) ->
        #console.log("IndexItemsDesignsCategoriesByItemIdCollection fetch successful: ")
        #console.log(response)
        myModel = categories.first()
        self.setCategories(myModel.get('items_designs_categories'))
        self.setBrands(myModel.get('items_designs_brands'))
        self.setStyles(myModel.get('items_designs_styles'))
        self.setColors(myModel.get('items_designs_colors'))
        self.setMakes(myModel.get('items_designs_makes'))
 
 
 
 
 
 
  # TAKES: model
  # --> either ITEM or DESIGN
  
  unHighlight: ->
    
    #console.log("unHighlighting")
    
    $("[data-room-highlighted=true]").each( ->
      $(this).attr("src", $(this).attr("data-main-src-server"))
      $(this).attr("data-room-highlighted", false)
    )
  
  highlight: (model) ->
    
    @unHighlight()
       
    #console.log("highlighting", model)
    
    
    ###
    TODO
    ###
    
    type = model.get("type")
    
    switch type
      
      when "ITEM"
        
        img = $("[data-design-item-id=" + model.get("id") + "]")
        #console.log("ITEM", img)
      
      when "DESIGN"
        
        img = $("[data-design-item-id=" + model.get("item_id") + "]")
        #console.log("DESIGN", img)
        
        
        
    
    # highlight the image if it isn't hidden
    if img.attr("data-room-hide") isnt "yes"
      
      original_src = img.attr("src")
      new_src =      img.attr("data-hover-src-client")
      
      #console.log("old src", original_src)
      #console.log("new src", new_src)
      
      img.attr("src", img.attr("data-hover-src-client"))
  
      # Change the highlighted property
      img.attr("data-room-highlighted", true)
    
    
    
 
 
 
 
  
  
  
  
  
  
  
  #--------------------------
  # get the items designs data
  #--------------------------
  getItemsDesignsCollection: (item_id)->
    itemsDesignsCollection = new Mywebroom.Collections.IndexItemsDesignsByItemIdCollection()
    itemsDesignsCollection.fetch
      async  : false
      url    : itemsDesignsCollection.url item_id
      success: (response) ->
        #console.log("initial design fetch success", response)
    
    return itemsDesignsCollection
    
    
    
    
    
    
    

  
  
  
  setCategories: (categories) ->
    # empty out existing dropdown items
    $('#dropdown-object > .dropdown-menu').empty()
    
    
    # iterate through the category items and create a li out of each one
    _.each(categories, (category) ->
      if category.category
        $('#dropdown-object > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(category.category) + '</a></li>')
    )


    
  setBrands: (brands) ->
    # empty out existing dropdown items
    $('#dropdown-brand > .dropdown-menu').empty()
    
    
    # iterate through the brand items and create a li out of each one
    _.each(brands, (brand) ->
      if brand.brand
        $('#dropdown-brand > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(brand.brand) + '</a></li>')
    )
    
    
    
  setStyles: (styles) ->
    # empty out existing dropdown items
    $('#dropdown-style > .dropdown-menu').empty()
    
    
    # iterate through the style items and create a li out of each one
    _.each(styles, (style) ->
      if style.style
        $('#dropdown-style > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(style.style) + '</a></li>')
    )
    
   
   
  setColors: (colors) ->
    # empty out existing dropdown items
    $('#dropdown-color > .dropdown-menu').empty()
    
    
    # iterate through the color items and create a li out of each one
    _.each(colors, (color) ->
      if color.color
        $('#dropdown-color > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(color.color) + '</a></li>')
    )
    
    
  setMakes: (makes) ->
    # empty out existing dropdown items
    $('#dropdown-make > .dropdown-menu').empty()
    
    
    # iterate through the make items and create a li out of each one
    _.each(makes, (make) ->
      if make.make
        $('#dropdown-make > .dropdown-menu').append('<li class=\"store-filter-item\"><a href=\"#\">' + _.str.capitalize(make.make) + '</a></li>')
    )
  
    
    
    
    
    


 
 
 
 
 
 
 
    
    
    
  
  
  
  
  collapseAll: ->
    # Add the collapse class
    $('#dropdown-object').addClass('collapse')
    $('#dropdown-style').addClass('collapse')
    $('#dropdown-brand').addClass('collapse')
    $('#dropdown-location').addClass('collapse')
    $('#dropdown-color').addClass('collapse')
    $('#dropdown-make').addClass('collapse')



  expandAll: ->
    # Remove the collapse class
    $('#dropdown-object').removeClass('collapse')
    $('#dropdown-style').removeClass('collapse')
    $('#dropdown-brand').removeClass('collapse')
    $('#dropdown-location').removeClass('collapse')
    $('#dropdown-color').removeClass('collapse')
    $('#dropdown-make').removeClass('collapse')
    
    
    





  
  
  
  
  
  
  
  #*******************
  #**** Functions  - append Collection to room store page
  #*******************

  #--------------------------
  # append items designs views
  #--------------------------

  appendHidden:(itemsDesignsCollection) ->

    $("#tab_hidden > ul").remove()
    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_item_designs_" + @row_number + "'></ul>"
    this.$('#tab_hidden').append(@row_line)

    that = this
    itemsDesignsCollection.each (entry)  ->
      storeMenuItemsDesignsView = new Mywebroom.Views.StorePreviewView(model:entry)
      $('#row_item_designs_' + that.row_number).append(storeMenuItemsDesignsView.el)
      storeMenuItemsDesignsView.render()
      that.loop_number += 1

      u = that.loop_number % that.column_number
      if u is 0
        that.row_number += 1
        that.row_line = "<ul id='row_item_designs_" + that.row_number + "'></ul>"
        $('#tab_hidden').append(that.row_line)





 
  
  
  
  #*******************
  #**** Funtions -
  #*******************
  #-------------------------------
  # Center the element to the room 
  #-------------------------------
  setItemToCenter:(itemModel) ->
    
    #console.log("Center", itemModel)
    
   
    ###
    BASED ON X and Y COORDINATES
    ###
    item_location_x = parseInt(itemModel.get('x'))
    item_location_y = parseInt(itemModel.get('y'))
    
   
    #console.log('item location y', item_location_y)
    
    $('#xroom_items_0').attr('data-current_screen_position','0')
    $('#xroom_items_0').css({
      'left': Math.floor(-1999 - item_location_x + 100)
      #'top' : 20
    })
    
    #console.log('room top', $('#xroom_items_0').css('top'))
    #console.log('room bottom', $('#xroom_items_0').css('bottom'))
    
    $('#xroom_items_1').attr('data-current_screen_position','1')
    $('#xroom_items_1').css({
      'left': Math.floor(0 - item_location_x + 100)
      #'top' : 45
    })
    
    $('#xroom_items_2').attr('data-current_screen_position','2')
    $('#xroom_items_2').css({
      'left': Math.floor(1999 - item_location_x + 100)
      #'top' : 70
    })





  hoverOn: (e) ->
    
    e.preventDefault()
    $('#store_' + @type + '_container_' + @model.get('id')).append(@button_preview)
  
    
  hoverOff: (e) ->
    
    e.preventDefault()
    $('#button_preview').remove()
    

  
  
  
