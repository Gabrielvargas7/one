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
      success: (response) ->
        #console.log("initial items fetch success", response)
      error: ->
        console.log("initial items fetch fail")
    
    Mywebroom.State.set("initialItems", items)
    
  
    # themes
    themes = new Mywebroom.Collections.IndexThemesCollection()
    themes.fetch
      async:   false
      success: (response) ->
        #console.log("initial theme fetch success", response)
      error: ->
        console.log("initial theme fetch fail")
    
    
  
    # bundles
    bundles = new Mywebroom.Collections.IndexBundlesCollection()
    bundles.fetch
      async:   false
      success: (response) ->
        #console.log("initial bundle fetch success", response)
      error: ->
        console.log("initial bundle fetch fail")
        
        
    # entire rooms
    entireRooms = new Mywebroom.Collections.IndexBundlesCollection()
    entireRooms.fetch
      async:   false
      success: (response) ->
        #console.log("initial entire room fetch success", response)
      error: ->
        console.log("initial entire room fetch fail")
      
      
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
  clickNavTab: (e) ->
    
    #console.log("Manual tab switch")
    
    e.preventDefault()
    #e.stopPropagation() <-- Prevents tabs from functioning
    
    ###
    SWITCH THE SEARCH DROPDOWN TO ALL - START
    ###
    $('#store-search-dropdown li').removeClass('active') # Remove active class
    $("#store-search-all").addClass("active") # Add active class to ALL
    $('#store-dropdown-btn').text("ALL") # Change the text of the search filter to ALL
    
  
  
    
    
  clickObjects: (e) ->
    
    #console.log("OBJECTS clicked")
    
    e.preventDefault()
    #e.stopPropagation() <-- Prevents tab from working
    
    # Hide the Save, Cancel, Remove view
    $('#xroom_store_menu_save_cancel_remove').hide()
    
    # Hide the search filters
    Mywebroom.Helpers.collapseFilters()
    
    
    
    
  clickThemes: (e) ->
    
    #console.log("THEMES clicked")
     
    e.preventDefault()
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
    
    
    # Load the Bundles' Categories Collection
    categories = new Mywebroom.Collections.IndexThemesCategoriesCollection()
    categories.fetch
      async: false
      success: (response) ->
        model = response.first()
        Mywebroom.Helpers.setBrands(model.get('themes_brands'))
        Mywebroom.Helpers.setStyles(model.get('themes_styles'))
        Mywebroom.Helpers.setLocations(model.get('themes_locations'))
        Mywebroom.Helpers.setColors(model.get('themes_colors'))
        Mywebroom.Helpers.setMakes(model.get('themes_makes'))
      error: (response) ->
        console.log("theme fetch fail")
        console.log(response)
    
    
   
   
      
  clickBundles: (e) ->
    
    e.preventDefault()
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
    
    
    # Load the Bundles' Categories Collection
    categories = new Mywebroom.Collections.IndexBundlesCategoriesCollection()
    categories.fetch
      async:   false
      success: (response) ->
        model = response.first()
        Mywebroom.Helpers.setBrands(model.get('bundles_brands'))
        Mywebroom.Helpers.setStyles(model.get('bundles_styles'))
        Mywebroom.Helpers.setLocations(model.get('bundles_locations'))
        Mywebroom.Helpers.setColors(model.get('bundles_colors'))
        Mywebroom.Helpers.setMakes(model.get('bundles_makes'))
      error: ->
        console.log("bundle category fail")
  
  
  
  clickEntireRooms: (e) ->
    
    e.preventDefault()
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
    
    
    # Load the Bundles' Categories Collection
    categories = new Mywebroom.Collections.IndexBundlesCategoriesCollection()
    categories.fetch
      async:   false
      success: (response) ->
        model = response.first()
        Mywebroom.Helpers.setBrands(model.get('bundles_brands'))
        Mywebroom.Helpers.setStyles(model.get('bundles_styles'))
        Mywebroom.Helpers.setLocations(model.get('bundles_locations'))
        Mywebroom.Helpers.setColors(model.get('bundles_colors'))
        Mywebroom.Helpers.setMakes(model.get('bundles_makes'))
      error: ->
        console.log("bundle category fail")
  
  
  
  
  clickSearchFilter: (e) ->

    e.preventDefault()
    #e.stopPropagation() <-- This prevents the nav pills from closing automatically
    
    # Switch to the hidden tab
    $('#storeTabs a[href="#tab_hidden"]').tab('show')

    keyword =  e.target.text
    category = Mywebroom.State.get("storeHelper")
    
    # PERFORM THE SEARCH
    @performSearch(keyword, category)
    
    
   
  
  keyupSearch: (e) ->
    
    e.preventDefault()
    e.stopPropagation()
    
    if e.keyCode is 13
      
      #console.log("SEARCH")
      
      # Switch to the hidden tab
      $('#storeTabs a[href="#tab_hidden"]').tab('show')
      
      
      # Contents of search
      input = $("#store-search-box").val()
      
      
      # What tab is selected?
      tab = $("#store-dropdown-btn").text()
      
      
      # Perform search
      @performSearch(input, tab)
      
      
      ###
      Clear search box
      ###
      $("#store-search-box").val("")
      
      
      
  clickSearchDropdown: (e) ->
    
    #console.log("SEARCH DROPDOWN CHANGE")
    
    e.preventDefault()
    #e.stopPropagation() <-- This prevents the dropdown menu from closing automatically
    
    # SEARCH DROPDOWN
    # Remove active class
    $('#store-search-dropdown li').removeClass('active')
    
    
    # Add active class to just-clicked element
    $(e.target).parent().addClass('active')
    
    
    # Change the text of the search filter
    $('#store-dropdown-btn').text(e.target.text)
    
    
    # TAB-PANE
    # Active the correct store-nav tab
    navName = e.target.text
    
    switch navName
      when 'ALL'
        $('a[href="#tab_items"]').tab('show')
        @clickObjects()
      when 'OBJECTS'
        $('a[href="#tab_items"]').tab('show')
        @clickObjects()
      when 'THEMES'
        $('a[href="#tab_themes"]').tab('show')
        @clickThemes()
      when 'BUNDLES'
        $('a[href="#tab_bundles"]').tab('show')
        @clickBundles()
      when 'ENTIRE ROOMS'
        $('a[href="#tab_entire_rooms"]').tab('show')
        @clickEntireRooms()
  
        
  
  
  
  performSearch: (keyword, category) ->
    
    self = this
    
    
    switch category
      when "ALL"
        ###
        Fetch designs collection
        ###
        designs = new Mywebroom.Collections.IndexSearchesItemsDesignsWithLimitAndOffsetAndKeywordCollection()
        designs.fetch
          async  : false
          url    : designs.url(10, 0, keyword)
          success: (response) ->
            #console.log("searched designs success", response)
          error: ->
            console.log("error")
            
            
        ###
        Fetch themes collection
        ###
        themes = new Mywebroom.Collections.IndexSearchesThemesWithLimitAndOffsetAndKeywordCollection()
        themes.fetch
           async: false
           url: themes.url(10, 0, keyword)
           success: (response) ->
             #console.log("searched themes success", response)
           error: ->
             console.log("error")
            
        
        ###
        Fetch bundles collection
        ###
        bundles = new Mywebroom.Collections.IndexSearchesBundlesWithLimitAndOffsetAndKeywordCollection()
        bundles.fetch
          async: false
          url: bundles.url(10, 0, keyword)
          success: (response) ->
            #console.log("searched bundles success", response)
          error: ->
            console.log("error")
            
            
            
        ###
        Fetch entire rooms collection
        ###
        entireRooms = new Mywebroom.Collections.IndexSearchesBundlesWithLimitAndOffsetAndKeywordCollection()
        entireRooms.fetch
          async  : false
          url    : entireRooms.url(10, 0, keyword)
          success: (response) ->
            #console.log("searched entire rooms I success", response)
          error: ->
            console.log("error")
            
        
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
          url    : collection.url(10,0,keyword)
          success: (response) ->
            #console.log("searched designs success", response)
            
            # Replace the views on the hidden tab
            self.appendHidden(response)
      
          error: ->
            console.log("error")

      when "THEMES"
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesThemesWithLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async: false
          url: collection.url(10, 0, keyword)
          success: (response) ->
            #console.log("searched themes success", response)
        
            # Replace the views on the hidden tab
            self.appendHidden(response)
  
          error: ->
            console.log("error")
      
      when "BUNDLES" 
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesBundlesWithLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async: false
          url: collection.url(10, 0, keyword)
          success: (response) ->
            #console.log("searched bundles success", response)
      
            # Replace the views on the hidden tab
            self.appendHidden(response)
            
          error: ->
            console.log("error")
            
      when "ENTIRE ROOMS"  
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesBundlesWithLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async  : false
          url    : collection.url(10, 0, keyword)
          success: (response) ->
            #console.log("searched entire rooms success", response)
          error: ->
            console.log("error")
            
        
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
          url:     collection.url(category,10,0,keyword)
          success: (response) ->
            #console.log("searched designs success", response)
    
            # Replace the views on the hidden tab
            self.appendHidden(response)

          error: ->
            console.log("error")
  
  
  
  
  #--------------------------
  # Append Item Views
  #--------------------------
  appendItems: (collection) ->
    
    $("#tab_items > ul").remove()
    
    @loop_number   = 0
    @row_number    = 1
    @column_number = 3

    @row_line = "<ul id='row_item_" + @row_number + "'></ul>"
    this.$('#tab_items').append(@row_line)

    self = this

    collection.each (item)  ->
      view = new Mywebroom.Views.StorePreviewView(model: item)
      $('#row_item_' + self.row_number).append(view.el)
      view.render()

      self.loop_number += 1
      u = self.loop_number % self.column_number

      if u is 0
        self.row_number += 1
        self.row_line = "<ul id='row_item_" + self.row_number + "'></ul>"
        $('#tab_items').append(self.row_line)


  #--------------------------
  # Append Design Views
  #--------------------------
  appendHidden: (designs) ->

    $("#tab_hidden > ul").remove()
    
    @loop_number   = 0
    @row_number    = 1
    @column_number = 3

    @row_line = "<ul id='row_item_designs_" + @row_number + "'></ul>"
    this.$('#tab_hidden').append(@row_line)

    self = this
    
    designs.each (design)  ->
      view = new Mywebroom.Views.StorePreviewView(model: design)
      $('#row_item_designs_' + self.row_number).append(view.el)
      view.render()
      
      # Show the social view
      view.addSocialView()
      
      self.loop_number += 1
      u = self.loop_number % self.column_number
      
      if u is 0
        self.row_number += 1
        self.row_line = "<ul id='row_item_designs_" + self.row_number + "'></ul>"
        $('#tab_hidden').append(self.row_line)


  #--------------------------
  # Append Theme Views
  #--------------------------
  appendThemes: (themes) ->
    
    $("#tab_themes > ul").remove()
    
    @loop_number   = 0
    @row_number    = 1
    @column_number = 3

    @row_line = "<ul id='row_theme_" + @row_number + "'></ul>"
    this.$('#tab_themes').append(@row_line)

    self = this

    themes.each (theme)  ->
      view = new Mywebroom.Views.StorePreviewView(model: theme)
      $('#row_theme_' + self.row_number).append(view.el)
      view.render()

      self.loop_number += 1
      u = self.loop_number % self.column_number

      if u is 0
        self.row_number += 1
        self.row_line = "<ul id='row_theme_" + self.row_number + "'></ul>"
        $('#tab_themes').append(self.row_line)



  #--------------------------
  # Append Bundle Views
  #--------------------------
  appendBundles: (bundles) ->
    
    $("#tab_bundles > ul").remove()
    
    @loop_number   = 0
    @row_number    = 1
    @column_number = 3

    @row_line = "<ul id='row_bundle_" + @row_number + "'></ul>"
    this.$('#tab_bundles').append(@row_line)

    self = this

    bundles.each (bundle)  ->
      view = new Mywebroom.Views.StorePreviewView(model: bundle)
      $('#row_bundle_' + self.row_number).append(view.el)
      view.render()

      self.loop_number += 1
      u = self.loop_number % self.column_number

      if u is 0
        self.row_number += 1
        self.row_line = "<ul id='row_bundle_" + self.row_number + "'></ul>"
        $('#tab_bundles').append(self.row_line)


  #--------------------------
  # Append Entire Room View
  #--------------------------
  appendEntireRooms: (entireRooms) ->
    
    $("#tab_entire_rooms > ul").remove()
    
    @loop_number   = 0
    @row_number    = 1
    @column_number = 3

    @row_line = "<ul id='row_bundle_set_" + @row_number + "'></ul>"
    this.$('#tab_entire_rooms').append(@row_line)
    
    self = this

    entireRooms.each (room)  ->
      view = new Mywebroom.Views.StorePreviewView(model: room)
      $('#row_bundle_set_' + self.row_number).append(view.el)
      view.render()

      self.loop_number += 1
      u = self.loop_number % self.column_number

      if u is 0
        self.row_number += 1
        self.row_line = "<ul id='row_bundle_set_" + self.row_number + "'></ul>"
        $('#tab_entire_rooms').append(self.row_line)




  
  
  
  
  
  
  
  
  
  
  
  
  appendOne: (model) ->
    
    console.log("appendOne")

    ###
    This is the code for receiving a model from 
    the social view
    ###
    if model.get("entityId")?
      ###
      We're getting a special form of design model
      that doesn't fit with all the other designs
      we fetch. So, we're going to use this model's
      entityId and then do a fetch for this model.
      ###
      item_id = model.get("entityId")
    
      usable = new Mywebroom.Models.ShowItemDesignById({id: item_id})
      usable.fetch
        async: false
        success: (model, response, options) ->
          #console.log("model fetch success", model, response, options)
        error: (model, response, options) ->
          console.log("model fetch fail", model, response, options)
    else
      ###
      This is the code for receiving a model from
      the profile view
      ###

      usable = model
      usable.set("type", "DESIGN")

      
    
    # Clear What's In There
    $("#tab_hidden > ul").remove()
    
   
    # Append this to it
    this.$('#tab_hidden').append("<ul id='row_item_designs_1'></ul>")

   
    # Create the view
    view = new Mywebroom.Views.StorePreviewView(model: usable)
    
    
    # Append the element
    $('#row_item_designs_1').append(view.el)
    
    
    # Render the view
    view.render()
    
    
    # Center the item
    Mywebroom.Helpers.centerItem(usable.get("item_id"))
    
    
    # Insert the item into the DOM and Conditionally Show the Save Bar
    Mywebroom.Helpers.updateRoomDesign(usable)
    
    
    # Conditionally Show the Save Bar
    Mywebroom.Helpers.showSaveBar()
    
    
    # Show the social view
    view.addSocialView()
