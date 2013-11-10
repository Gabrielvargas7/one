class Mywebroom.Views.StoreMenuView extends Backbone.View
  
  
  #*******************
  #**** Template
  #*******************
  template: JST['store/StoreMenuTemplate']
  
  
  #*******************
  #**** Events
  #*******************
  events: {
    'click #storeTabs a':                'clickNavTab'         # NAV TABS (any)
    'click a[href="#tab_items"]':        'clickObjects'        # NAV TABS: OBJECTS
    'click a[href="#tab_themes"]':       'clickThemes'         # NAV TABS: THEMES
    'click a[href="#tab_bundles"]':      'clickBundles'        # NAV TABS: BUNDLES
    'click a[href="#tab_entire_rooms"]': 'clickEntireRooms'    # NAV TABS: ENTIRE ROOMS
    'keyup #store-search-box':           'keyupSearch'         # SEARCH
    'click #store-search-dropdown li a': 'clickSearchDropdown' # SEARCH DROPDOWN
    'click .store-filter-item a':        'clickSearchFilter'   # SEARCH FILTER
  }


  
  
  #*******************
  #**** Render
  #*******************
  render: ->

    ###
    RENDER VIEW
    ###
    $(@el).append(@template())
   
    
    
    
    
    ###
    FETCH INITIAL DATA - START
    ###
    # items
    items = new Mywebroom.Collections.IndexItemsCollection()
    items.fetch
      async:   false
      success: (collection, response, options) ->
        #console.log("initial items fetch success", collection)
      error: (collection, response, options) ->
        console.log("initial items fetch fail", response.responseText)
    
    Mywebroom.State.set("initialItems", items)
    
    
    ###
    Set the objects we use to keep handy info about the items
    ###
    Mywebroom.Helpers.setItemRefs()
    
  
    # themes
    themes = new Mywebroom.Collections.IndexThemesCollection()
    themes.fetch
      async: false
      success: (collection, response, options) ->
        #console.log("initial theme fetch success", collection)
      error: (collection, response, options) ->
        console.error("initial theme fetch fail", response.responseText)
    
    
  
    # bundles
    bundles = new Mywebroom.Collections.IndexBundlesCollection()
    bundles.fetch
      async:   false
      success: (collection, response, options) ->
        #console.log("initial bundle fetch success", collection)
      error: (collection, response, responseText) ->
        console.error("initial bundle fetch fail", response.responseText)
        
        
    # entire rooms
    entireRooms = new Mywebroom.Collections.IndexBundlesCollection()
    entireRooms.fetch
      async: false
      success: (collection, response, options) ->
        #console.log("initial entire room fetch success", collection)
      error: (collection, response, options) ->
        console.error("initial entire room fetch fail", response.responseText)
      
      
    copy = entireRooms.clone()
    
    
    parsed = copy.map((model) ->
      obj = model
      model.set("type", "ENTIRE_ROOM")
      return obj
    )
    
    
    reset = copy.reset(parsed)
    ###
    FETCH INITIAL DATA - END
    ###
    
    
    
    
    ###
    SPLAT DATA TO STORE - START
    ###
    @appendItems(items)       # ITEMS
    @appendThemes(themes)     # THEMES
    @appendBundles(bundles)   # BUNDLES
    @appendEntireRooms(reset) # ENTIRE ROOMS
    
    
    
    
    
    ###
    CONVENTION
    ###
    this
   
    
  
  
   
  #*******************
  #**** Events
  #*******************
  clickNavTab: (event) ->
    
    #console.log("Manual tab switch")
    
    event.preventDefault()
    #e.stopPropagation() <-- Prevents tabs from functioning
    
    ###
    SWITCH THE SEARCH DROPDOWN TO ALL - START
    ###
    $('#store-search-dropdown li').removeClass('active') # Remove active class
    $("#store-search-all").addClass("active") # Add active class to ALL
    $('#store-dropdown-btn').text("ALL") # Change the text of the search filter to ALL


    ###
    SCROLL TO THE TOP
    ###
    $('.tab-content').scrollTop(0)

    
  
  
    
    
  clickObjects: (event) ->
    
    #console.log("OBJECTS clicked")
    
    event.preventDefault()
    #e.stopPropagation() <-- Prevents tab from working



    ###
    FIXME
    THIS SHOULDN'T BE NECESSARY! WHY DID THIS BREAK?
    ###
    if not $('#tab_items').is(':visible')
      $('#storeTabs a[href="#tab_items"]').tab('show')


    if $('#store-search-dropdown').is(':visible')
      console.log("BUG: DROPDOWN MENU SHOULD CLOSE")
      #$('#store-search-dropdown').dropdown('toggle') <-- turns off dropdown permanently!



    
    # Hide the Save, Cancel, Remove view
    $('#xroom_store_menu_save_cancel_remove').hide()
    
    # Hide the search filters
    Mywebroom.Helpers.collapseFilters()

    # Turn pagination off
    Mywebroom.Data.Editor.paginate = false
    
    
    
    
  clickThemes: (event) ->
    
    #console.log("THEMES clicked")

    event.preventDefault()
    #e.stopPropagation() <-- Prevents tab from working
    
    ###
    Set our store helper
    ###
    Mywebroom.State.set("storeHelper", "THEMES")
    
    
    
    # Hide the Save, Cancel, Remove view
    $('#xroom_store_menu_save_cancel_remove').hide()
    
    
    # Re-show nav pills
    Mywebroom.Helpers.expandFilters()
    
    
     # Add the collapse class
    $('#dropdown-category').addClass('collapse')


    ###
    PAGINATION
    ###
    Mywebroom.Data.Editor.paginate = true
    Mywebroom.Data.Editor.contentPath = "INITIAL"
    Mywebroom.Data.Editor.contentType = "THEMES"
    
    
    # Load the Bundles' Categories Collection
    categories = new Mywebroom.Collections.IndexThemesCategoriesCollection()
    categories.fetch
      async: false
      success: (collection, response, options) ->
        model = collection.first()
        Mywebroom.Helpers.setBrands(model.get('themes_brands'))
        Mywebroom.Helpers.setStyles(model.get('themes_styles'))
        Mywebroom.Helpers.setLocations(model.get('themes_locations'))
        Mywebroom.Helpers.setColors(model.get('themes_colors'))
        Mywebroom.Helpers.setMakes(model.get('themes_makes'))
      error: (collection, response, options) ->
        console.error("theme fetch fail", response.responseText)
       
    
    
   
  
  clickBundles: (event) ->
    
    event.preventDefault()
    #e.stopPropagation() <-- Prevents tab from working
    
    
    ###
    Set our store helper
    ###
    Mywebroom.State.set("storeHelper", "BUNDLES")
    
    
    
    # Hide the Save, Cancel, Remove view
    $('#xroom_store_menu_save_cancel_remove').hide()
    
    
    # Re-show nav pills
    Mywebroom.Helpers.expandFilters()
    
    
    # Add the collapse class
    $('#dropdown-category').addClass('collapse')


    ###
    PAGINATION
    ###
    Mywebroom.Data.Editor.paginate = true
    Mywebroom.Data.Editor.contentPath = "INITIAL"
    Mywebroom.Data.Editor.contentType = "BUNDLES"
    
    
    # Load the Bundles' Categories Collection
    categories = new Mywebroom.Collections.IndexBundlesCategoriesCollection()
    categories.fetch
      async:   false
      success: (collection, response, options) ->
        model = collection.first()
        Mywebroom.Helpers.setBrands(model.get('bundles_brands'))
        Mywebroom.Helpers.setStyles(model.get('bundles_styles'))
        Mywebroom.Helpers.setLocations(model.get('bundles_locations'))
        Mywebroom.Helpers.setColors(model.get('bundles_colors'))
        Mywebroom.Helpers.setMakes(model.get('bundles_makes'))
      error: (collection, response, options) ->
        console.error("bundle category fail", response.responseText)
  
  
  
  clickEntireRooms: (event) ->
    
    event.preventDefault()
    #e.stopPropagation() <-- Prevents tab from working
    
    ###
    Set our store helper
    ###
    Mywebroom.State.set("storeHelper", "ENTIRE ROOMS")
    
    
    # Hide the Save, Cancel, Remove view
    $('#xroom_store_menu_save_cancel_remove').hide()
    
   
    # Re-show nav pills
    Mywebroom.Helpers.expandFilters()
    
    
    # Add the collapse class
    $('#dropdown-category').addClass('collapse')


    ###
    PAGINATION
    ###
    Mywebroom.Data.Editor.paginate = true
    Mywebroom.Data.Editor.contentPath = "INITIAL"
    Mywebroom.Data.Editor.contentType = "ENTIRE ROOMS"
    
    
    # Load the Bundles' Categories Collection
    categories = new Mywebroom.Collections.IndexBundlesCategoriesCollection()
    categories.fetch
      async:   false
      success: (collection, response, options) ->
        model = collection.first()
        Mywebroom.Helpers.setBrands(model.get('bundles_brands'))
        Mywebroom.Helpers.setStyles(model.get('bundles_styles'))
        Mywebroom.Helpers.setLocations(model.get('bundles_locations'))
        Mywebroom.Helpers.setColors(model.get('bundles_colors'))
        Mywebroom.Helpers.setMakes(model.get('bundles_makes'))
      error: (collection, response, options) ->
        console.error("bundle category fail", response.responseText)
  
  
  
  
  clickSearchFilter: (event) ->

    event.preventDefault()
    #e.stopPropagation() <-- This prevents the nav pills from closing automatically
    
    # Switch to the hidden tab
    $('#storeTabs a[href="#tab_hidden"]').tab('show')


    keyword =  event.target.text
    category = Mywebroom.State.get("storeHelper")
    
    # PERFORM THE SEARCH
    @performSearch(category, keyword)
    
    
   
  
  keyupSearch: (event) ->
    
    event.preventDefault()
    event.stopPropagation()
    
    if event.keyCode is 13
      
      #console.log("EDITOR SEARCH")
      
      # Switch to the hidden tab
      $('#storeTabs a[href="#tab_hidden"]').tab('show')
      
      
      # Contents of search
      input = $("#store-search-box").val()
      
      
      # What tab is selected?
      tab = $("#store-dropdown-btn").text()
      
      
      # Perform search
      @performSearch(tab, input)

      
      
      ###
      Clear search box
      ###
      $("#store-search-box").val("")
      
      
      
  clickSearchDropdown: (event) ->
    
    #console.log("SEARCH DROPDOWN CHANGE")
    
    event.preventDefault()
    #e.stopPropagation() <-- This prevents the dropdown menu from closing automatically
    
    # SEARCH DROPDOWN
    # Remove active class
    $('#store-search-dropdown li').removeClass('active')
    
    
    # Add active class to just-clicked element
    $(event.target).parent().addClass('active')
    
    
    # Change the text of the search filter
    $('#store-dropdown-btn').text(event.target.text)
    
    
    # TAB-PANE
    # Active the correct store-nav tab
    navName = event.target.text
    
    switch navName
      
      when 'ALL'
        $('a[href="#tab_items"]').tab('show')
        @clickObjects(event)
      
      when 'OBJECTS'
        $('a[href="#tab_items"]').tab('show')
        @clickObjects(event)
      
      when 'THEMES'
        $('a[href="#tab_themes"]').tab('show')
        @clickThemes(event)
      
      when 'BUNDLES'
        $('a[href="#tab_bundles"]').tab('show')
        @clickBundles(event)
      
      when 'ENTIRE ROOMS'
        $('a[href="#tab_entire_rooms"]').tab('show')
        @clickEntireRooms(event)
  
        
  
  
  
  performSearch: (category, keyword) ->
    
    ###
    PAGINATION
    ###
    Mywebroom.Data.Editor.paginate = true
    Mywebroom.Data.Editor.contentPath = "SEARCH"
    Mywebroom.Data.Editor.contentType = category
    Mywebroom.Data.Editor.keyword = keyword
    


    self = this
    
    
    switch category
      when "ALL"
        ###
        Fetch designs collection
        ###
        designs = new Mywebroom.Collections.IndexSearchesItemsDesignsWithLimitAndOffsetAndKeywordCollection()
        designs.fetch
          async: false
          url: designs.url(10, 0, keyword)
          success: (collection, response, options) ->
            console.log(collection.length + " designs found! <-- ALL")
          
          error: (collection, response, options) ->
            console.error("search all: designs fetch fail", response.responseText)
            
            
        ###
        Fetch themes collection
        ###
        themes = new Mywebroom.Collections.IndexSearchesThemesWithLimitAndOffsetAndKeywordCollection()
        themes.fetch
          async: false
          url: themes.url(10, 0, keyword)
          success: (collection, response, options) ->
            console.log(collection.length + " themes found! <-- ALL")
          
          error: ->
            console.error("search all: themes fetch fail", response.responseText)
            
        
        ###
        Fetch bundles collection
        ###
        bundles = new Mywebroom.Collections.IndexSearchesBundlesWithLimitAndOffsetAndKeywordCollection()
        bundles.fetch
          async: false
          url: bundles.url(10, 0, keyword)
          success: (collection, response, options) ->
            console.log(collection.length + " bundles found! <-- ALL")
          
          error: (collection, response, options) ->
            console.error("search all: bundles fetch fail", response.responseText)
            
            
            
        ###
        Fetch entire rooms collection
        ###
        entireRooms = new Mywebroom.Collections.IndexSearchesBundlesWithLimitAndOffsetAndKeywordCollection()
        entireRooms.fetch
          async: false
          url: entireRooms.url(10, 0, keyword)
          success: (collection, response, options) ->
            console.log(collection.length + " entire rooms found! <-- ALL")
          
          error: (collection, response, options) ->
            console.error("search all: entire rooms fetch fail", response.responseText)
            
        
        ###
        This is a bundles collection, but we're going to use it as a collection of
        entire room objects. This means we need to override it's type property.
        
        Note that since this mapping is being done outside of the collection's parse
        method, we need to reset our collection with the model data after mapping.
        http://stackoverflow.com/questions/17034593/how-does-map-work-with-a-backbone-collection
        ###
        
        # Override the type property
        parsed = entireRooms.map((model) ->
          obj = model
          obj.set("type", "ENTIRE_ROOM")
          return obj
        )
        
        # Reset the collection
        reset = entireRooms.reset(parsed)
        #console.log("searched entire rooms II success", reset)
        
    
        ###
        NOW COMBINE ALL THE COLLECTIONS
        ###
        data = designs.toJSON().concat(themes.toJSON()).concat(bundles.toJSON()).concat(reset.toJSON())
        everything = new Backbone.Collection(data)


        console.log(everything.length + " total things found! <-- ALL")
        
        
        #console.log("everything", everything)
        
        
        # Now splat it to the screen
        self.appendHidden(everything)
        
        
        
      when "OBJECTS"
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesItemsDesignsWithLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async  : false
          url    : collection.url(10, 0, keyword)
          success: (collection, response, options) ->
            
            console.log(collection.length + " designs found!")
            
            # Replace the views on the hidden tab
            self.appendHidden(collection)
      
          error: (collection, response, options) ->
            console.error("search objects fetch fail", response.responseText)

      when "THEMES"
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesThemesWithLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async: false
          url: collection.url(10, 0, keyword)
          success: (collection, response, options) ->
            
            console.log(collection.length + " themes found!")

            # Replace the views on the hidden tab
            self.appendHidden(collection)
  
          error: (collection, response, options) ->
            console.error("search themes fetch fail", response.responseText)
      
      when "BUNDLES"
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesBundlesWithLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async: false
          url: collection.url(10, 0, keyword)
          success: (collection, response, options) ->

            console.log(collection.length + " bundles found!")
      
            # Replace the views on the hidden tab
            self.appendHidden(collection)
            
          error: (collection, response, options) ->
            console.error("search bundles fetch fail", response.responseText)
            
      when "ENTIRE ROOMS"
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesBundlesWithLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async  : false
          url    : collection.url(10, 0, keyword)
          success: (collection, response, options) ->
            
            console.log(collection.length + " entire rooms found!")

          error: (collection, response, options) ->
            console.error("search entire rooms fetch fail", response.responseText)
            
        
        ###
        This is a bundles collection, but we're going to use it as a collection of
        entire room objects. This means we need to override it's type property.
        
        Note that since this mapping is being done outside of the collection's parse
        method, we need to reset our collection with the model data after mapping.
        http://stackoverflow.com/questions/17034593/how-does-map-work-with-a-backbone-collection
        ###
        
        # Override the type property
        parsed = collection.map((model) ->
          obj = model
          obj.set("type", "ENTIRE_ROOM")
          return obj
        )
        
        # Reset the collection
        reset = collection.reset(parsed)

        console.log(reset.length + " entire rooms found! (after parse)")
    
        # Replace the views on the hidden tab
        self.appendHidden(reset)
                 
      else
        ###
        Looks like it's a specific design category (number)
        ###
        
        #console.log("YOU'RE SEARCHING ON ITEM DESIGN CATEGORY ", category)
        
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesItemsDesignsWithItemIdAndLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async:   false
          url:     collection.url(category, 10, 0, keyword)
          success: (collection, response, options) ->

            console.log(collection.length + " designs found!")
    
            # Replace the views on the hidden tab
            self.appendHidden(collection)

          error: (collection, response, options) ->
            console.error("search designs fetch fail", response.responseText)
  
  
  
  
  #--------------------------
  # Append Item Views
  #--------------------------
  appendItems: (collection) ->
    
    $("#tab_items > ul").remove()
    
    loop_number   = 0
    row_number    = 1
    column_number = 3

    row_line = "<ul id='row_item_1'></ul>"
    $('#tab_items').append(row_line)

    
    collection.each (item) ->
      view = new Mywebroom.Views.StorePreviewView(model: item)
      $('#row_item_' + row_number).append(view.el)
      view.render()

      loop_number += 1
      u = loop_number % column_number

      if u is 0
        row_number += 1
        row_line = "<ul id='row_item_" + row_number + "'></ul>"
        $('#tab_items').append(row_line)


  #--------------------------
  # Append Design Views
  #--------------------------
  appendHidden: (designs) ->

    $("#tab_hidden > ul").remove()
    
    loop_number =   0
    row_number =    1
    column_number = 3

    row_line = "<ul id='row_item_designs_1'></ul>"
    $('#tab_hidden').append(row_line)

    
    designs.each (design) ->
      view = new Mywebroom.Views.StorePreviewView(model: design)
      $('#row_item_designs_' + row_number).append(view.el)
      view.render()
      
      # Show the social view
      view.addSocialView()
      
      loop_number += 1
      u = loop_number % column_number
      
      if u is 0
        row_number += 1
        row_line = "<ul id='row_item_designs_" + row_number + "'></ul>"
        $('#tab_hidden').append(row_line)


  #--------------------------
  # Append Theme Views
  #--------------------------
  appendThemes: (themes) ->
    
    $("#tab_themes > ul").remove()
    
    loop_number =   0
    row_number =    1
    column_number = 3

    row_line = "<ul id='row_theme_1'></ul>"
    $('#tab_themes').append(row_line)


    themes.each (theme) ->
      view = new Mywebroom.Views.StorePreviewView(model: theme)
      $('#row_theme_' + row_number).append(view.el)
      view.render()

      # Show the social view
      view.addSocialView()
      
      loop_number += 1
      u = loop_number % column_number

      if u is 0
        row_number += 1
        row_line = "<ul id='row_theme_" + row_number + "'></ul>"
        $('#tab_themes').append(row_line)



  #--------------------------
  # Append Bundle Views
  #--------------------------
  appendBundles: (bundles) ->
    
    $("#tab_bundles > ul").remove()
    
    loop_number =   0
    row_number =    1
    column_number = 3

    row_line = "<ul id='row_bundle_1'></ul>"
    $('#tab_bundles').append(row_line)


    bundles.each (bundle) ->
      view = new Mywebroom.Views.StorePreviewView(model: bundle)
      $('#row_bundle_' + row_number).append(view.el)
      view.render()

      # Show the social view
      view.addSocialView()
      
      loop_number += 1
      u = loop_number % column_number

      if u is 0
        row_number += 1
        row_line = "<ul id='row_bundle_" + row_number + "'></ul>"
        $('#tab_bundles').append(row_line)


  #--------------------------
  # Append Entire Room View
  #--------------------------
  appendEntireRooms: (entireRooms) ->
    
    $("#tab_entire_rooms > ul").remove()
    
    loop_number =   0
    row_number =    1
    column_number = 3

    row_line = "<ul id='row_bundle_set_1'></ul>"
    $('#tab_entire_rooms').append(row_line)
    

    entireRooms.each (room) ->
      view = new Mywebroom.Views.StorePreviewView(model: room)
      $('#row_bundle_set_' + row_number).append(view.el)
      view.render()

      # Show the social view
      view.addSocialView()
      
      loop_number += 1
      u = loop_number % column_number

      if u is 0
        row_number += 1
        row_line = "<ul id='row_bundle_set_" + row_number + "'></ul>"
        $('#tab_entire_rooms').append(row_line)




  
  
  
  
  
  
  
  
  
  
  
  
  appendOne: (model) ->
    

    ###
    Make sure model has type and
    create reference if it does
    ###
    if model.has("type")
      type = model.get("type")
    else
      throw new Error("model without type")

 

      
    
    # Clear What's In There
    $("#tab_hidden > ul").remove()
    
   
    # Append this to it
    $('#tab_hidden').append("<ul id='row_item_designs_1'></ul>")

   
    # Create the view
    view = new Mywebroom.Views.StorePreviewView(model: model)
    
    
    # Append the element
    $('#row_item_designs_1').append(view.el)
    
    
    # Render the view
    view.render()


    # Show the social view
    view.addSocialView()
    
    

    ###
    DO STUFF DEPENDING ON THE TYPE OF THE MODEL
    ###
    switch type

      when "DESIGN"
        
        # Center the item
        Mywebroom.Helpers.centerItem(model.get("item_id"))

        # Insert the item into the DOM
        Mywebroom.Helpers.updateRoomDesign(model)

        ###
        CONDITIONALLY SHOW SAVE BAR
        ###
        Mywebroom.Helpers.showSaveBar()


      

      when "THEME"

        # Insert the item into the DOM
        Mywebroom.Helpers.updateRoomTheme(model)

        ###
        CONDITIONALLY SHOW SAVE BAR
        ###
        Mywebroom.Helpers.showSaveBar()




      when "BUNDLE"
        
        ###
        FETCH DESIGNS
        ###
        designs = new Mywebroom.Collections.IndexItemsDesignsOfBundleByBundleIdCollection()
        designs.fetch
          async: false
          url: designs.url(model.get("id"))
          success: (collection, response, options) ->
            #console.log("designs fetch success")
          error: (collection, response, options) ->
            console.error("design fetch fail", response.responseText)


        ###
        UPDATE DOM
        ###
        designs.each (design) ->

          Mywebroom.Helpers.updateRoomDesign(design)
           
        
        ###
        CONDITIONALLY SHOW SAVE BAR
        ###
        Mywebroom.Helpers.showSaveBar()
        
          
        ###
        NEVER SHOW REMOVE BUTTON FOR A BUNDLE
        ###
        $('#xroom_store_remove').hide()




      when "ENTIRE_ROOM"

        ###
        FETCH THEME
        ###
        theme = new Mywebroom.Models.ShowThemeByIdModel({id: model.get("theme_id")})
        theme.fetch
          async:   false
          success: (model, response, options) ->
            #console.log("theme fetch success")
          error: (model, response, options) ->
            console.error("theme fetch fail", response.responseText)
        
        
        ###
        THEME: UPDATE DOM
        ###
        Mywebroom.Helpers.updateRoomTheme(theme)
        
        
        
        
        ###
        FETCH DESIGNS
        ###
        designs = new Mywebroom.Collections.IndexItemsDesignsOfBundleByBundleIdCollection()
        designs.fetch
          async: false
          url: designs.url(model.get("id"))
          success: (collection, response, options) ->
            #console.log("designs fetch success")
          error: (collection, response, options) ->
            console.error("designs fetch fail", response.responseText)

        
        
        ###
        DESIGNS: UPDATE DOM
        ###
        designs.each (design) ->
          
          Mywebroom.Helpers.updateRoomDesign(design)
          
          
        
        ###
        CONDITIONALLY SHOW SAVE BAR
        ###
        Mywebroom.Helpers.showSaveBar()
        
        

        ###
        NEVER SHOW REMOVE BUTTON FOR AN ENTIRE ROOM
        ###
        $('#xroom_store_remove').hide()
