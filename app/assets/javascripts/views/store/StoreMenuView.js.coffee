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

  events:
    'click #objects-store-menu'         :'clickObjects'
    'click #themes-store-menu'          :'clickThemes'
    'click #bundles-store-menu'         :'clickBundles'
    'click #entire-rooms-store-menu'    :'clickBundles'
    'click #store-dropdown-all'         :'clickAllDropdown'
    'click #store-dropdown-objects'     :'clickObjectsDropdown'
    'click #store-dropdown-themes'      :'clickThemesDropdown'
    'click #store-dropdown-bundles'     :'clickBundlesDropdown'
    'click #store-dropdown-entire-rooms':'clickEntireRoomsDropdown'
    'click .store-dropdown'             :'clickStoreDropdown'
    
    
  clickStoreDropdown: (e) ->
    # DROPDOWN
    # Remove active class
    $('.store-dropdown').removeClass('active')
    
    # Add active class to just-clicked element
    $(e.target).parent().addClass('active')
    
    # Change the text of the search filter
    $('#store-dropdown-btn').text(e.target.text)
    
    
    # TAB-PANE
    # Remove active class for store-nav
    # $('.store-nav').removeClass('active')
    
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
        @clickBundles()
      

  #*******************
  #**** Initialize
  #*******************
  initialize: ->

  #*******************
  #**** Render
  #*******************
  render: ->
    console.log("storemenu view: ")
    console.log(@model)

    $(@el).append(@template())

    # hide object tab ItemsDesignsTab
#    this.hideItemsDesignsTab()

    # items
    @itemsCollection = this.getItemsCollection()
    this.appendItemsEntry(@itemsCollection)

    # items designs
    @itemsDesignsCollection = this.getItemsDesignsCollection(@itemsCollection.first().get('id'))
    this.appendItemsDesignsEntry(@itemsDesignsCollection)

    # themes
    @themesCollection = this.getThemesCollection()
    this.appendThemesEntry(@themesCollection)

    # bundles
    @bundlesCollection = this.getBundlesCollection()
    this.appendBundlesEntry(@bundlesCollection)

    # bundles set
    this.appendBundlesSetEntry(@bundlesCollection)


    this



  #*******************
  #**** Functions  - get Collection
  #*******************

  #--------------------------
  # get the items data
  #--------------------------
  getItemsCollection: ->
    itemsCollection = new Mywebroom.Collections.IndexItemsCollection()
    itemsCollection.fetch async: false
    return itemsCollection

  #--------------------------
  # get the items designs data
  #--------------------------
  getItemsDesignsCollection: (item_id) ->
    itemsDesignsCollection = new Mywebroom.Collections.IndexItemsDesignsByItemIdCollection()
    itemsDesignsCollection.fetch
      async:false
      url:itemsDesignsCollection.url item_id
      success:(response) ->
        console.log("items designs fetch successful: ")
        console.log(response)
    return itemsDesignsCollection


  #--------------------------
  # get the Themes data
  #--------------------------
  getThemesCollection: ->
    themesCollection = new Mywebroom.Collections.IndexThemesCollection()
    themesCollection.fetch async: false
#    console.log(JSON.stringify(this.themesCollection.toJSON()))
    return themesCollection

  #--------------------------
  # get the Bundles data
  #--------------------------
  getBundlesCollection: ->
    bundlesCollection = new Mywebroom.Collections.IndexBundlesCollection()
    bundlesCollection.fetch async: false
#    console.log(JSON.stringify(this.bundlesCollection.toJSON()))
    return bundlesCollection


  #*******************
  #**** Functions  - append Collection to room store page
  #*******************

  #--------------------------
  # append items views
  #--------------------------
  appendItemsEntry:(itemsCollection) ->
    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_item_"+@row_number+"'></ul>"
    $('#tab_items').append(@row_line)

    that = this

    itemsCollection.each (entry)  ->
      storeMenuItemsView = new Mywebroom.Views.StoreMenuItemsView(model:entry)
      $('#row_item_'+that.row_number).append(storeMenuItemsView.el)
      storeMenuItemsView.render()

      that.loop_number++
      u = that.loop_number%that.column_number

      if u == 0
       that.row_number++
       that.row_line = "<ul id='row_item_"+that.row_number+"'></ul>"
       $('#tab_items').append(that.row_line)


  #--------------------------
  # append items designs views
  #--------------------------

  appendItemsDesignsEntry:(itemsDesignsCollection) ->

    $("#tab_items_designs > ul").remove()
    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_item_designs_"+@row_number+"'></ul>"
    this.$('#tab_items_designs').append(@row_line)

    that = this
    itemsDesignsCollection.each (entry)  ->
      storeMenuItemsDesignsView = new Mywebroom.Views.StoreMenuItemsDesignsView(model:entry)
      $('#row_item_designs_'+that.row_number).append(storeMenuItemsDesignsView.el)
      storeMenuItemsDesignsView.render()
      that.loop_number++

      u = that.loop_number%that.column_number
      if u == 0
        that.row_number++
        that.row_line = "<ul id='row_item_designs_"+that.row_number+"'></ul>"
        $('#tab_items_designs').append(that.row_line)


  #--------------------------
  # append themes views
  #--------------------------
  appendThemesEntry:(themesCollection) ->
    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_theme_"+@row_number+"'></ul>"
    $('#tab_themes').append(@row_line)

    that = this

    themesCollection.each (entry)  ->
      storeMenuThemesView = new Mywebroom.Views.StoreMenuThemesView(model:entry)
      $('#row_theme_'+that.row_number).append(storeMenuThemesView.el)
      storeMenuThemesView.render()

      that.loop_number++
      u = that.loop_number%that.column_number

      if u == 0
        that.row_number++
        that.row_line = "<ul id='row_theme_"+that.row_number+"'></ul>"
        $('#tab_themes').append(that.row_line)



  #--------------------------
  # append Bundle views
  #--------------------------
  appendBundlesEntry:(bundlesCollection) ->
    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_bundle_"+@row_number+"'></ul>"
    $('#tab_bundles').append(@row_line)

    that = this

    bundlesCollection.each (entry)  ->
      storeMenuBundlesView = new Mywebroom.Views.StoreMenuBundlesView(model:entry)
      $('#row_bundle_'+that.row_number).append(storeMenuBundlesView.el)
      storeMenuBundlesView.render()

      that.loop_number++
      u = that.loop_number%that.column_number

      if u == 0
        that.row_number++
        that.row_line = "<ul id='row_bundle_"+that.row_number+"'></ul>"
        $('#tab_bundles').append(that.row_line)


  #--------------------------
  # append Bundles Set views
  #--------------------------
  appendBundlesSetEntry:(bundlesCollection) ->
    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_bundle_set_"+@row_number+"'></ul>"
    $('#tab_entire_rooms').append(@row_line)
    that = this

    bundlesCollection.each (entry)  ->
      storeMenuBundlesSetView = new Mywebroom.Views.StoreMenuBundlesSetView(model:entry)
      $('#row_bundle_set_'+that.row_number).append(storeMenuBundlesSetView.el)
      storeMenuBundlesSetView.render()

      that.loop_number++
      u = that.loop_number%that.column_number

      if u == 0
        that.row_number++
        that.row_line = "<ul id='row_bundle_set_"+that.row_number+"'></ul>"
        $('#tab_entire_rooms').append(that.row_line)




  #*******************
  #**** Functions  - hide tabs
  #*******************

  #--------------------------
  # hide items designs tap
  #--------------------------
  hideItemsDesignsTab: ->
    $tab_item_designs = $('[data-toggle="tab"][href="#tab_items_designs"]')
    $tab_item_designs.hide()



  collapseAll: ->
    # Add the collapse class
    $('#dropdown-object').addClass('collapse')
    $('#dropdown-style').addClass('collapse')
    $('#dropdown-brand').addClass('collapse')
    $('#dropdown-location').addClass('collapse');
    $('#dropdown-color').addClass('collapse');
    $('#dropdown-make').addClass('collapse');



  expandAll: ->
    # Remove the collapse class
    $('#dropdown-object').removeClass('collapse')
    $('#dropdown-style').removeClass('collapse')
    $('#dropdown-brand').removeClass('collapse')
    $('#dropdown-location').removeClass('collapse');
    $('#dropdown-color').removeClass('collapse');
    $('#dropdown-make').removeClass('collapse');



  clickObjects: ->      
    @collapseAll()
    
    
    
  clickThemes: ->
    self = this
    
    @expandAll()
    
    
     # Add the collapse class
    $('#dropdown-object').addClass('collapse');
    
    
    # Load the Bundles' Categories Collection
    categories = new Mywebroom.Collections.IndexThemesCategoriesCollection();
    categories.fetch();
    categories.on('sync', -> 
      model = this.first();
      self.setBrands(model.get('themes_brands'))
      self.setStyles(model.get('themes_styles'))
      self.setLocations(model.get('themes_locations'))
      self.setColors(model.get('themes_colors'))
      self.setMakes(model.get('themes_makes'))
    )  
    
    
    
    
  clickBundles: ->
    self = this
    
    @expandAll()
    
    
    # Add the collapse class
    $('#dropdown-object').addClass('collapse');
    
    
    # Load the Bundles' Categories Collection
    categories = new Mywebroom.Collections.IndexBundlesCategoriesCollection();
    categories.fetch();
    categories.on('sync', -> 
      model = this.first();
      self.setBrands(model.get('bundles_brands'))
      self.setStyles(model.get('bundles_styles'))
      self.setLocations(model.get('bundles_locations'))
      self.setColors(model.get('bundles_colors'))
      self.setMakes(model.get('bundles_makes'))
    )
  
  
    
  setBrands: (brands) ->
    # empty out existing dropdown items
    $('#dropdown-brand > .dropdown-menu').empty()
    
    
    # iterate through the brand items and create a li out of each one
    _.each(brands, (brand) ->
      if brand.brand
        $('#dropdown-brand > .dropdown-menu').append('<li class=\"store-dropdown-item\"><a href=\"#\">'+_.str.capitalize(brand.brand)+'</a></li>');
    )
    
    
    
  setStyles: (styles) ->
    # empty out existing dropdown items
    $('#dropdown-style > .dropdown-menu').empty()
    
    
    # iterate through the style items and create a li out of each one
    _.each(styles, (style) ->
      if style.style
        $('#dropdown-style > .dropdown-menu').append('<li class=\"store-dropdown-item\"><a href=\"#\">'+_.str.capitalize(style.style)+'</a></li>');
    )
    
    
  setLocations: (locations) ->
    # empty out existing dropdown items
    $('#dropdown-location > .dropdown-menu').empty()
    
    
    # iterate through the location items and create a li out of each one
    _.each(locations, (location) ->
      if location.location
        $('#dropdown-location > .dropdown-menu').append('<li class=\"store-dropdown-item\"><a href=\"#\">'+_.str.capitalize(location.location)+'</a></li>');
    )
   
   
  setColors: (colors) ->
    # empty out existing dropdown items
    $('#dropdown-color > .dropdown-menu').empty()
    
    
    # iterate through the color items and create a li out of each one
    _.each(colors, (color) ->
      if color.color
        $('#dropdown-color > .dropdown-menu').append('<li class=\"store-dropdown-item\"><a href=\"#\">'+_.str.capitalize(color.color)+'</a></li>');
    )
    
    
  setMakes: (makes) ->
    # empty out existing dropdown items
    $('#dropdown-make > .dropdown-menu').empty()
    
    
    # iterate through the make items and create a li out of each one
    _.each(makes, (make) ->
      if make.make
        $('#dropdown-make > .dropdown-menu').append('<li class=\"store-dropdown-item\"><a href=\"#\">'+_.str.capitalize(make.make)+'</a></li>');
    )
       
    
    
  