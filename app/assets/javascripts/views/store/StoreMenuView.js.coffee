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




    ###
    Turn on hover
    ###
    if Object.keys(Mywebroom.Data.ItemModels).length then Mywebroom.Helpers.turnOnHover()
    
  


    # themes
    themes = Mywebroom.Helpers.Editor.paginateInitial("THEMES", 10, 0)
  


  
    # bundles
    bundles = Mywebroom.Helpers.Editor.paginateInitial("BUNDLES", 10, 0)
  



    # entire rooms
    entireRooms = Mywebroom.Helpers.Editor.paginateInitial("ENTIRE ROOMS", 10, 0)




    ###
    FETCH INITIAL DATA - END
    ###
    
    
    
    
    ###
    SPLAT DATA TO STORE - START
    ###
    Mywebroom.State.set('tabContentItems', items)
    Mywebroom.State.set('tabContentThemes', themes)
    Mywebroom.State.set('tabContentBundles', bundles)
    Mywebroom.State.set('tabContentEntireRooms', entireRooms)

   
    
    
    
    
    
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
    #if not $('#tab_items').is(':visible') <-- yeah, this works now. wtf.
      #console.log("had to manually show tab...")
      #$('#storeTabs a[href="#tab_items"]').tab('show')


    #if $('#store-search-dropdown').is(':visible')
      #console.log("BUG: DROPDOWN MENU SHOULD CLOSE") <-- um... now this is working ??
      #$('#store-search-dropdown').dropdown('toggle') <-- turns off dropdown permanently!



    
    # Hide the Save, Cancel, Remove view
    $('#xroom_store_menu_save_cancel_remove').hide()
    
    # Hide the search filters
    Mywebroom.Helpers.collapseFilters()

    # Turn pagination off
    Mywebroom.Data.Editor.paginate = false
    Mywebroom.Data.Editor.offset = 0 # <-- is this necessary?
    
    
    
    
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
    Mywebroom.Data.Editor.offset = 0
    
    
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
    Mywebroom.Data.Editor.offset = 0
    
    
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
    Mywebroom.Data.Editor.offset = 0
    
    
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
    Mywebroom.Data.Editor.offset = 0
    



    limit = Mywebroom.Data.Editor.limit



    
    data = Mywebroom.Helpers.Editor.paginateSearch(category, limit, 0, keyword)


    
    Mywebroom.State.set('tabContentHidden', data)
  
  
  
 


  
 


  
  
  
  
  
  
  
  
  
  
  
  
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
    view = new Mywebroom.Views.StorePreviewView({model: model})
    
    
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
