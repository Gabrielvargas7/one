class Mywebroom.Views.StorePreviewView  extends Backbone.View

  #*******************
  #**** Tag 
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
    'click .store_container_ITEM':        'clickItem'
    'click .store_container_DESIGN':      'clickDesign'
    'click .store_container_THEME':       'clickTheme'
    'click .store_container_BUNDLE':      'clickBundle'
    'click .store_container_ENTIRE_ROOM': 'clickEntireRoom'
    'mouseenter .store_container':        'hoverOn'
    'mouseleave .store_container':        'hoverOff' 
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
  #**** Events
  #*******************
  clickItem: (e) ->
    
    #console.log("click item")
   
    e.preventDefault()
    e.stopPropagation()
   
    ###
    (1) Change to hidden tab
    (2) Conditionally show remove button
    (3) Conditionally highlight room item
    (4) Fetch corresponding designs
    (5) Update views
    (6) Center item
    (7) Update filters
    ###
    
   
   
    # Switch to the hidden tab
    $('#storeTabs a[href="#tab_hidden"]').tab('show');
    
    
  
       
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
      
      
      ###
      Highlight Image
      ###
      Mywebroom.Helpers.highLight(itemId)
      
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
      
      
     
   
   
    ###
    FETCH CORRESPONDING DESIGNS
    ###
    designs = new Mywebroom.Collections.IndexItemsDesignsByItemIdCollection()
    designs.fetch
      async  : false
      url    : designs.url(itemId)
      success: (response) ->
        #console.log("initial design fetch success", response)
    
    
    
    
    ###
    UPDATE VIEWS
    ###
    @appendHidden(designs)
    
    
    
    
    ###
    CENTER ITEM
    ###
    Mywebroom.Helpers.centerItem(itemId)
    
    
    
    
    ###
    FILTERS - START
    ###
    # Show all the dropdown filters
    Mywebroom.Helpers.expandFilters()
   
   
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
        Mywebroom.Helpers.setCategories(myModel.get('items_designs_categories'))
        Mywebroom.Helpers.setBrands(myModel.get('items_designs_brands'))
        Mywebroom.Helpers.setStyles(myModel.get('items_designs_styles'))
        Mywebroom.Helpers.setColors(myModel.get('items_designs_colors'))
        Mywebroom.Helpers.setMakes(myModel.get('items_designs_makes'))
    ###
    FILTERS - END
    ###
 
 
  
  
  
  
  
  
  
  
  
  clickDesign: (e) ->
    
    e.preventDefault()
    e.stopPropagation()
    
    ###
    (1) Center
    (2) Conditionally Show Save Bar
    (3) Update DOM
    (4) Highlight
    ###
    
    
    #console.log("click design")
     
    
    ###
    DESIGN TYPE
    ###
    design_type = @model.get("item_id")
    
    
    ###
    NEW PROPERTIES
    ###
    new_design_id = @model.get("id")
    new_main_src =  @model.get("image_name").url
    new_hover_src = @model.get("image_name_hover").url
    
    
   
  
    ###
    CENTER
    ###
    Mywebroom.Helpers.centerItem(design_type)
    
    
    
    
    
    
    ###
    SAVE, CANCEL, REMOVE - START
    ###
    # Show the Save, Cancel, Remove view
    $("#xroom_store_menu_save_cancel_remove").show()
    
    # Show the save button
    $('#xroom_store_save').show()
    
    # Show the cancel button
    $('#xroom_store_cancel').show()
    
    # Show the remove button unless the current design is hidden
    unless $("[data-design-item-id=" + design_type + "]").attr("data-room-hide") is "yes"
      $('#xroom_store_remove').show()
    ###
    SAVE, CANCEL, REMOVE - END
    ###
    
    
    
    
    
    
    
    
    
    ###
    UPDATE DOM PROPERTIES - START
    ###
    $('[data-design-item-id=' + design_type + ']')
    .attr("src", new_hover_src)
    .attr("data-design-id-client", new_design_id)
    .attr("data-main-src-client", new_main_src)
    .attr("data-hover-src-client", new_hover_src)
    .attr("data-design-has-changed", true)
    .attr("data-room-highlighted", true)
    ###
    UPDATE DOM PROPERTIES - END
    ###
    
    
   
    # Highlight
    Mywebroom.Helpers.highLight(design_type)
    
    
    
    
    
    # Find the design that was clicked and
    # create a reference to it's container element
    $activeDesign = $("[data-design-item-id=" + design_type + "]")
    

    # Save this object to our state model
    Mywebroom.State.set("$activeDesign", $activeDesign)
    
          
   
    
    

    
    
 
 
 
  
  clickTheme: (e) ->
    
    e.preventDefault()
    e.stopPropagation()
    
    # New Properties
    url =      @model.get('image_name').url
    theme_id = @model.get('id')
    
    
    # Show the view with the Save, Cancel, Remove buttons
    $('#xroom_store_menu_save_cancel_remove').show()
    
    
    # SET STATE OF SAVE, CANCEL, REMOVE BUTTONS
    # Show the save button
    $('#xroom_store_save').show()
    
    # Show the cancel button
    $('#xroom_store_cancel').show()
    
    # Hide the remove button
    $('#xroom_store_remove').hide()
    
    
    
    $('.current_background').attr("src", url)
    $('.current_background').attr("data-theme-id-client", theme_id)
    $('.current_background').attr("data-theme-src-client", url)
    $('.current_background').attr("data-theme-has-changed", true)

  
  clickBundle: (e) ->
    
    #console.log("click Store Bundle View " + @model.get('id'))
    
    e.preventDefault()
    e.stopPropagation()
    
    
    # Show the view with the Save, Cancel, Remove buttons
    $('#xroom_store_menu_save_cancel_remove').show()
    
    
    # SET STATE OF SAVE, CANCEL, REMOVE BUTTONS
    # Show the save button
    $('#xroom_store_save').show()
    
    # Show the cancel button
    $('#xroom_store_cancel').show()
    
    # Hide the remove button
    $('#xroom_store_remove').hide()
    
    
    collection = @getBundleDesignsCollection(@model.get('id'))

    collection.each (entry)  ->
      itemId = entry.get('item_id')
      itemDesignId = entry.get('id')
      imageName = entry.get('image_name').url
      imageNameHover = entry.get('image_name_hover').url

      $('[data-design-item-id=' + itemId + ']').attr("src", imageName)
      $('[data-design-item-id=' + itemId + ']').attr("data-design-id-server",itemDesignId)
      $('[data-design-item-id=' + itemId + ']').hover (->  $(this).attr("src",imageNameHover)), -> $(this).attr("src",imageName)
      $('[data-design-item-id=' + itemId + ']').attr("data-design-has-changed", true)






  
  clickEntireRoom: (e) ->
    
    e.preventDefault()
    e.stopPropagation()
    
    
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
    bundleThemeCollection = @getBundleThemeCollection(@model.get('theme_id'))
    bundleThemeModel = bundleThemeCollection.first()
    $('.current_background').attr("src", bundleThemeModel.get('image_name').url);
    $('.current_background').attr("data-theme-id-client", bundleThemeModel.get('id'));
    $('.current_background').attr("data-theme-has-changed", true);


    # set the new items
    collection = @getBundleDesignsCollection(@model.get('id'))
    collection.each (entry) ->
      itemId =         entry.get('item_id')
      itemDesignId =   entry.get('id')
      imageName =      entry.get('image_name').url
      imageNameHover = entry.get('image_name_hover').url

      $('[data-design-item-id=' + itemId + ']').attr("src", imageName)
      $('[data-design-item-id=' + itemId + ']').attr("data-design-id-server", itemDesignId)
      $('[data-design-item-id=' + itemId + ']').hover (->  $(self).attr("src", imageNameHover)), -> $(self).attr("src", imageName)
      $('[data-design-item-id=' + itemId + ']').attr("data-design-has-changed", true)
  
  
  
  
  hoverOn: (e) ->
    
    e.preventDefault()
    e.stopPropagation()
    
    $('#store_' + @type + '_container_' + @model.get('id')).append(@button_preview)
  
  
  
    
  hoverOff: (e) ->
    
    e.preventDefault()
    e.stopPropagation()
    
    $('#button_preview').remove()
  
  
  
  
  #--------------------------
  # Fetch Bundle Designs
  #--------------------------
  getBundleDesignsCollection: (id) ->
    collection = new Mywebroom.Collections.IndexItemsDesignsOfBundleByBundleIdCollection()
    collection.fetch
      async:   false
      url:     collection.url(id)
      success: (response) ->
        #console.log("bundle design collection fetch success", response)
      error: ->
        console.log("bundle design collection fail")

    return collection


  #--------------------------
  # Fetch Bundle Theme
  #--------------------------
  getBundleThemeCollection: (id) ->
    collection = new Mywebroom.Collections.ShowThemeByThemeIdCollection()
    collection.fetch
      async:   false
      url:     collection.url(id)
      success: (response) ->
        #console.log("bundle theme collection fetch success", response)
      error: ->
        console.log("bundle theme collection fail")

    return collection
  
  
  
  
  #--------------------
  # Append Design Views
  #--------------------
  appendHidden: (collection) ->

    $("#tab_hidden > ul").remove()
    
    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_item_designs_" + @row_number + "'></ul>"
    this.$('#tab_hidden').append(@row_line)

    self = this
    collection.each (model)  ->
      view = new Mywebroom.Views.StorePreviewView(model: model)
      $('#row_item_designs_' + self.row_number).append(view.el)
      view.render()
      self.loop_number += 1

      u = self.loop_number % self.column_number
      if u is 0
        self.row_number += 1
        self.row_line = "<ul id='row_item_designs_" + self.row_number + "'></ul>"
        $('#tab_hidden').append(self.row_line)
