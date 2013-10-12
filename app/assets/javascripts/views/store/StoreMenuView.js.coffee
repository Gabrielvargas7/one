class Mywebroom.Views.StoreMenuView extends Backbone.View
  
  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************
  
  
  #*******************
  #**** Templeate
  #*******************
  template: JST['store/StoreMenuTemplate']
  
  #*******************
  #**** Events
  #*******************
  
  events: {
    'shown #storeTabs a[data-toggle="tab"]': 'navSwitch'      # NAV SWITCH
    'click #storeTabs a':                'manualNavSwitch'    # NAV SWITCH - MANUAL
    'click a[href="#tab_items"]':        'clickObjects'       # NAV TABS
    'click a[href="#tab_themes"]':       'clickThemes'        # NAV TABS
    'click a[href="#tab_bundles"]':      'clickBundles'       # NAV TABS
    'click a[href="#tab_entire_rooms"]': 'clickEntireRooms'   # NAV TABS
    'click a[href="#tab_hidden"]':       'clickHidden'        # NAV TABS <-- Can this ever be triggered??
    'keyup #store-search-box':           'keyupSearch'        # SEARCH
    'click #store-search-dropdown li a': 'searchDropdownChange'     # SEARCH DROPDOWN
    'click .store-dropdown-item a':      'filterSearch'             # FILTER
  }
  
    
  #*******************
  #**** Initialize
  #*******************
  initialize: ->
  
  #*******************
  #**** Render
  #*******************
  render: ->

    # THIS VIEW
    $(@el).append(@template())
  
  
    ###
    FETCH INITIAL DATA
    ###
  
    # items
    itemsCollection = @getItemsCollection()
    
  
    # themes
    themesCollection = @getThemesCollection()
    
  
  
    # bundles
    bundlesCollection = new Mywebroom.Collections.IndexBundlesCollection()
    bundlesCollection.fetch
      async:   false
        
        
   
    entireRoomsCollection = new Mywebroom.Collections.IndexBundlesCollection()
    entireRoomsCollection.fetch
      async:   false
      
      
  
    copy = entireRoomsCollection.clone()
    
    parsed = copy.map((model) ->
      obj = model
      model.set("type", "ENTIRE_ROOM")
      return obj
    )
    
    reset = copy.reset(parsed)
    
    
  


    ###
    SPLAT DATA TO STORE
    ###
    
    @appendItemsEntry(itemsCollection)     # ITEMS
    @appendThemesEntry(themesCollection)   # THEMES
    @appendBundlesEntry(bundlesCollection) # BUNDLES
    @appendBundlesSetEntry(reset)          # ENTIRE ROOMS





    
    
    
    

    # As per convention, return a reference to this view
    this

  
  
  
  
  
  
  
  
  navSwitch: (e) ->
    
    ###
    THIS IS TRIGGERED FOR BOTH MANUAL CLICKS AS WELL AS 
    CHANGES OF THE SEARCH DROPDOWN
    
    WE ONLY WANT TO CHANGE THE SEARCH DROPDOWN
    WHEN SOMEONE MANUALLY CLICKS A SEARCH BOX
    ###
    
    
    
    console.log("tab switched")
    
    ###
    TODO
    What should happen now?
    ###

  
  manualNavSwitch: (e) ->
    
    console.log("Manual tab switch")
    
    ###
    SWITCH THE SEARCH DROPDOWN TO ALL
    ###
    
    # SEARCH DROPDOWN
    # Remove active class
    $('#store-search-dropdown li').removeClass('active')
    
    
    # Add active class to ALL
    $("#store-search-all").addClass("active")
    
    
    # Change the text of the search filter to ALL
    $('#store-dropdown-btn').text("ALL")
    
    
  
  
    
    
  filterSearch: (e) ->

    # Switch to the hidden tab
    $('#storeTabs a[href="#tab_hidden"]').tab('show')

    keyword  = e.target.text
    category = Mywebroom.State.get("storeHelper")
    
    # PERFORM THE SEARCH
    @search(keyword, category)
    
    
    
  
  search: (keyword, category) ->
    
    
    self = this
    
    switch category
      when "ALL"
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesItemsDesignsWithLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async  : false
          url    : collection.url(10, 0, keyword)
          success: (response) ->
            console.log("searched designs success", response)
            
            console.log("\n!!!\nWARNING! NOT EVERYTHING!\n!!!\n")
          
            # Replace the views on the hidden tab
            self.appendHidden(response)
    
          error: ->
            console.log("error")
      when "OBJECTS"
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesItemsDesignsWithLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async  : false
          url    : collection.url(10,0,keyword)
          success: (response) ->
            console.log("searched designs success", response)
            
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
            console.log("searched themes success", response)
        
            # Replace the views on the hidden tab
            self.appendHidden(response)
  
          error: ->
            console.log("error")
      
      when "BUNDLES"
        
        console.log("BUNDLES!!!!!!!!!!!!!")
        
        
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesBundlesWithLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async: false
          url: collection.url(10, 0, keyword)
          success: (response) ->
            console.log("searched bundles success", response)
      
            # Replace the views on the hidden tab
            self.appendHidden(response)
            
          error: ->
            console.log("error")
            
      when "ENTIRE_ROOM"
        
        
        console.log("ENTIRE ROOMS!!!!!!!!!!!!!")
        
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesBundlesWithLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async  : false
          url    : collection.url(10, 0, keyword)
          success: (response) ->
            console.log("searched entire rooms success", response)
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
        console.log("searched entire rooms II success", reset)
        
    
        # Replace the views on the hidden tab
        self.appendHidden(reset)
            
            
        
        
      else
        ###
        Looks like it's a specific design category (number)
        ###
        console.log("YOU'RE SEARCHING ON ITEM DESIGN CATEGORY ", category)
        console.log(category)
        ###
        Fetch collection
        ###
        collection = new Mywebroom.Collections.IndexSearchesItemsDesignsWithItemIdAndLimitAndOffsetAndKeywordCollection()
        collection.fetch
          async:   false
          url:     collection.url(category,10,0,keyword)
          success: (response) ->
            console.log("searched designs II success", response)
    
            # Replace the views on the hidden tab
            self.appendHidden(response)

          error: ->
            console.log("error")
  
  
    
  keyupSearch: (e) ->
    
    
    if e.keyCode is 13
      
      
      # Switch to the hidden tab
      $('#storeTabs a[href="#tab_hidden"]').tab('show')
      
      
      # Contents of search
      input = $("#store-search-box").val()
      
      
      # What tab is selected?
      tab = $("#store-dropdown-btn").text()
      
      
      # Perform search
      @search(input, tab)
      
      
      ###
      Clear search box
      ###
      $("#store-search-box").val("")
      
      
      
  makeDropdownAll: ->
    
    ###
    This algorithm works, but it appears 
    this can't be triggered from another function.
    
    Why is that? Does it have to do with function placement?
    ###
    
    # SEARCH DROPDOWN
    # Remove active class
    $('#store-search-dropdown li').removeClass('active')
    
    
    # Add active class to ALL
    $("#store-search-all").addClass("active")
    
    
    # Change the text of the search filter to ALL
    $('#store-dropdown-btn').text("ALL")
   
  
  
  
  
  searchDropdownChange: (e) ->
    
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
      

  

  #*******************
  #**** Functions  - get Collection
  #*******************

  #--------------------------
  # get the items data
  #--------------------------
  getItemsCollection: ->
    itemsCollection = new Mywebroom.Collections.IndexItemsCollection()
    itemsCollection.fetch
      async:   false
      success: (response) ->
        console.log("items fetch success", response)
    return itemsCollection

  #--------------------------
  # get the items designs data
  #--------------------------
  getItemsDesignsCollection: (item_id) ->
    
    itemsDesignsCollection = new Mywebroom.Collections.IndexItemsDesignsByItemIdCollection()
    itemsDesignsCollection.fetch
      async:   false
      url:     itemsDesignsCollection.url(item_id)
      success: (response) ->
        console.log("items design fetch success", response)
        
    return itemsDesignsCollection


  #--------------------------
  # get the Themes data
  #--------------------------
  getThemesCollection: ->
    themesCollection = new Mywebroom.Collections.IndexThemesCollection()
    themesCollection.fetch
      async:   false
      success: (response) ->
        console.log("initial theme fetch success", response)
    return themesCollection

  #--------------------------
  # get the Bundles data
  #--------------------------
  getBundlesCollection: ->
    bundlesCollection = new Mywebroom.Collections.IndexBundlesCollection()
    bundlesCollection.fetch
      async:   false
      success: (response) ->
        console.log("initial bundle fetch success", response)
        
    return bundlesCollection


  #*******************
  #**** Functions  - append Collection to room store page
  #*******************





  #--------------------------
  # append items views
  #--------------------------
  appendItemsEntry: (itemsCollection) ->
    
    $("#tab_items > ul").remove()
    
    @loop_number   = 0
    @row_number    = 1
    @column_number = 3

    @row_line = "<ul id='row_item_" + @row_number + "'></ul>"
    this.$('#tab_items').append(@row_line)

    self = this

    itemsCollection.each (entry)  ->
      storeMenuItemsView = new Mywebroom.Views.StorePreviewView(model:entry)
      $('#row_item_' + self.row_number).append(storeMenuItemsView.el)
      storeMenuItemsView.render()

      self.loop_number += 1
      u = self.loop_number % self.column_number

      if u is 0
        self.row_number += 1
        self.row_line = "<ul id='row_item_" + self.row_number + "'></ul>"
        $('#tab_items').append(self.row_line)


  #--------------------------
  # append items designs views
  #--------------------------
  appendHidden: (itemsDesignsCollection) ->

    $("#tab_hidden > ul").remove()
    
    @loop_number   = 0
    @row_number    = 1
    @column_number = 3

    @row_line = "<ul id='row_item_designs_" + @row_number + "'></ul>"
    this.$('#tab_hidden').append(@row_line)

    self = this
    
    itemsDesignsCollection.each (entry)  ->
      storeMenuItemsDesignsView = new Mywebroom.Views.StorePreviewView(model:entry)
      $('#row_item_designs_' + self.row_number).append(storeMenuItemsDesignsView.el)
      storeMenuItemsDesignsView.render()
      
      self.loop_number += 1
      u = self.loop_number % self.column_number
      
      if u is 0
        self.row_number += 1
        self.row_line = "<ul id='row_item_designs_" + self.row_number + "'></ul>"
        $('#tab_hidden').append(self.row_line)


  #--------------------------
  # append themes views
  #--------------------------
  appendThemesEntry: (themesCollection) ->
    
    $("#tab_themes > ul").remove()
    
    @loop_number   = 0
    @row_number    = 1
    @column_number = 3

    @row_line = "<ul id='row_theme_" + @row_number + "'></ul>"
    this.$('#tab_themes').append(@row_line)

    self = this

    themesCollection.each (entry)  ->
      storeMenuThemesView = new Mywebroom.Views.StorePreviewView(model: entry)
      $('#row_theme_' + self.row_number).append(storeMenuThemesView.el)
      storeMenuThemesView.render()

      self.loop_number += 1
      u = self.loop_number % self.column_number

      if u is 0
        self.row_number += 1
        self.row_line = "<ul id='row_theme_" + self.row_number + "'></ul>"
        $('#tab_themes').append(self.row_line)



  #--------------------------
  # append Bundle views
  #--------------------------
  appendBundlesEntry: (bundlesCollection) ->
    
    $("#tab_bundles > ul").remove()
    
    @loop_number   = 0
    @row_number    = 1
    @column_number = 3

    @row_line = "<ul id='row_bundle_" + @row_number + "'></ul>"
    this.$('#tab_bundles').append(@row_line)

    self = this

    bundlesCollection.each (entry)  ->
      storeMenuBundlesView = new Mywebroom.Views.StorePreviewView(model:entry)
      $('#row_bundle_' + self.row_number).append(storeMenuBundlesView.el)
      storeMenuBundlesView.render()

      self.loop_number += 1
      u = self.loop_number % self.column_number

      if u is 0
        self.row_number += 1
        self.row_line = "<ul id='row_bundle_" + self.row_number + "'></ul>"
        $('#tab_bundles').append(self.row_line)


  #--------------------------
  # append Bundles Set views
  #--------------------------
  appendBundlesSetEntry: (bundlesCollection) ->
    
    $("#tab_entire_rooms > ul").remove()
    
    @loop_number   = 0
    @row_number    = 1
    @column_number = 3

    @row_line = "<ul id='row_bundle_set_" + @row_number + "'></ul>"
    this.$('#tab_entire_rooms').append(@row_line)
    
    self = this

    bundlesCollection.each (entry)  ->
      storeMenuBundlesSetView = new Mywebroom.Views.StorePreviewView(model:entry)
      $('#row_bundle_set_' + self.row_number).append(storeMenuBundlesSetView.el)
      storeMenuBundlesSetView.render()

      self.loop_number += 1
      u = self.loop_number % self.column_number

      if u is 0
        self.row_number += 1
        self.row_line = "<ul id='row_bundle_set_" + self.row_number + "'></ul>"
        $('#tab_entire_rooms').append(self.row_line)




  
  
  
  
  
  
  
  
  
  #*******************
  #**** Filter Helpers
  #*******************
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



  
  
  
  
  
  
  #************
  # CLICKS ----
  #************
  clickObjects: ->
    
    # Hide the Save, Cancel, Remove view
    $('#xroom_store_menu_save_cancel_remove').hide()
    
    # Hide the search filters
    @collapseAll()
    
    
    ###
    TODO
    Update dropdown tab to be ALL
    ###
    
    
    
  clickThemes: ->
    
    console.log("click themes")
    
    
    ###
    Set our store helper
    ###
    Mywebroom.State.set("storeHelper", "THEMES")
    
    
    
    # Hide the Save, Cancel, Remove view
    $('#xroom_store_menu_save_cancel_remove').hide()
    
    self = this
    @expandAll()
    
    
     # Add the collapse class
    $('#dropdown-object').addClass('collapse')
    
    
    # Load the Bundles' Categories Collection
    categories = new Mywebroom.Collections.IndexThemesCategoriesCollection()
    categories.fetch
      async: false
      success: (response) ->
        model = response.first()
        self.setBrands(model.get('themes_brands'))
        self.setStyles(model.get('themes_styles'))
        self.setLocations(model.get('themes_locations'))
        self.setColors(model.get('themes_colors'))
        self.setMakes(model.get('themes_makes'))
      error: (response) ->
        console.log("theme fetch fail")
        console.log(response)
    
    
   
   
      
  clickBundles: ->
    
    
    
    ###
    Set our store helper
    ###
    Mywebroom.State.set("storeHelper", "BUNDLES")
    
    
    
    # Hide the Save, Cancel, Remove view
    $('#xroom_store_menu_save_cancel_remove').hide()
    
    self = this
    
    @expandAll()
    
    
    # Add the collapse class
    $('#dropdown-object').addClass('collapse')
    
    
    # Load the Bundles' Categories Collection
    categories = new Mywebroom.Collections.IndexBundlesCategoriesCollection()
    categories.fetch
      async:   false
      success: (response) ->
        model = response.first()
        self.setBrands(model.get('bundles_brands'))
        self.setStyles(model.get('bundles_styles'))
        self.setLocations(model.get('bundles_locations'))
        self.setColors(model.get('bundles_colors'))
        self.setMakes(model.get('bundles_makes'))
      error: ->
        console.log("bundle category fail")
  
  
  
  clickEntireRooms: ->
    
    ###
    Set our store helper
    ###
    Mywebroom.State.set("storeHelper", "ENTIRE_ROOM")
    
    
    
    # Hide the Save, Cancel, Remove view
    $('#xroom_store_menu_save_cancel_remove').hide()
    
    self = this
    
    @expandAll()
    
    
    # Add the collapse class
    $('#dropdown-object').addClass('collapse')
    
    
    # Load the Bundles' Categories Collection
    categories = new Mywebroom.Collections.IndexBundlesCategoriesCollection()
    categories.fetch
      async:   false
      success: (response) ->
        model = response.first()
        self.setBrands(model.get('bundles_brands'))
        self.setStyles(model.get('bundles_styles'))
        self.setLocations(model.get('bundles_locations'))
        self.setColors(model.get('bundles_colors'))
        self.setMakes(model.get('bundles_makes'))
      error: ->
        console.log("bundle category fail")
  
  
    
  
  
  
  
  
  
  
  clickHidden: ->
    ###
    DOES THIS FUNCTION NEED TO DO SOMETHING???
    ###
  
  
  
  
  #********************
  # FILTER SETTING ----
  #********************
  
  ###
  TODO
  There needs to be a function for setting objects
  ###

  setStyles: (styles) ->
    # empty out existing dropdown items
    $('#dropdown-style > .dropdown-menu').empty()
    
    
    # iterate through the style items and create a li out of each one
    _.each(styles, (style) ->
      if style.style
        $('#dropdown-style > .dropdown-menu').append('<li class=\"store-dropdown-item\"><a href=\"#\">' + _.str.capitalize(style.style) + '</a></li>')
    )
    
    
      
  setBrands: (brands) ->
    # empty out existing dropdown items
    $('#dropdown-brand > .dropdown-menu').empty()
    
    
    # iterate through the brand items and create a li out of each one
    _.each(brands, (brand) ->
      if brand.brand
        $('#dropdown-brand > .dropdown-menu').append('<li class=\"store-dropdown-item\"><a href=\"#\">' + _.str.capitalize(brand.brand) + '</a></li>')
    )
    
    
    
  setLocations: (locations) ->
    # empty out existing dropdown items
    $('#dropdown-location > .dropdown-menu').empty()
    
    
    # iterate through the location items and create a li out of each one
    _.each(locations, (location) ->
      if location.location
        $('#dropdown-location > .dropdown-menu').append('<li class=\"store-dropdown-item\"><a href=\"#\">' + _.str.capitalize(location.location) + '</a></li>')
    )
   
   
   
  setColors: (colors) ->
    # empty out existing dropdown items
    $('#dropdown-color > .dropdown-menu').empty()
    
    
    # iterate through the color items and create a li out of each one
    _.each(colors, (color) ->
      if color.color
        $('#dropdown-color > .dropdown-menu').append('<li class=\"store-dropdown-item\"><a href=\"#\">' + _.str.capitalize(color.color) + '</a></li>')
    )
    
    
  setMakes: (makes) ->
    # empty out existing dropdown items
    $('#dropdown-make > .dropdown-menu').empty()
    
    
    # iterate through the make items and create a li out of each one
    _.each(makes, (make) ->
      if make.make
        $('#dropdown-make > .dropdown-menu').append('<li class=\"store-dropdown-item\"><a href=\"#\">' + _.str.capitalize(make.make) + '</a></li>')
    )
