class Mywebroom.Views.StoreMenuItemsView  extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

  tagName: 'li'
  #*******************
  #**** Templeate
  #*******************
  template: JST['store/StoreMenuItemsTemplate']


  #*******************
  #**** Events
  #*******************
  events:
    'click .store_container_item'     :'clickStoreItem'
    'mouseenter .store_container_item':'hoverStoreItem'
    'mouseleave .store_container_item':'hoverOffStoreItem'


  #*******************
  #**** Initialize
  #*******************
  initialize: ->

  #*******************
  #**** Render
  #*******************
  render: ->
    $(@el).append(@template(item:@model))
    this


  #*******************
  #**** Funtions  -Collection
  #*******************





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

  #*******************
  #**** Funtions  -events
  #*******************

  #--------------------------
  # do something on click
  #--------------------------
  clickStoreItem: (event) ->  
    event.preventDefault()

        
    self   = this
    itemId = @model.get("id")
    
    
    
    
    
    
    
    # Un-hide the save, cancel, remove view
    $("#xroom_store_menu_save_cancel_remove").show()
    
    # Hide the buttons we don't want
    $("#xroom_store_save").hide()
    $("#xroom_store_cancel").hide()
    
    
    
    
    @moveToItemsDesignsTab()
    itemsDesignsCollection = @getItemsDesignsCollection(itemId)
    @appendItemsDesignsEntry(itemsDesignsCollection)
    @setItemToCenter(@model)
    
    # $("li").removeClass() <-- this is messing up the stuff below. which class do we actually want to remove?
    
    
    @expandAll()
    
    
    # COLLAPSE LOCATION
    $('#dropdown-location').addClass('collapse');
    
    
    
    
    # SET THE MENUS
    itemId = this.model.get('id')
    categories = new Mywebroom.Collections.IndexItemsDesignsCategoriesByItemIdCollection(itemId)
    categories.fetch()
    categories.on('sync', ->
      model = this.first();
      self.setCategories(model.get('items_designs_categories'))
      self.setBrands(model.get('items_designs_brands'))
      self.setStyles(model.get('items_designs_styles'))
      self.setColors(model.get('items_designs_colors'))
      self.setMakes(model.get('items_designs_makes'))
    )
  #--------------------------
  # get the items designs data
  #--------------------------
  getItemsDesignsCollection: (item_id)->
    itemsDesignsCollection = new Mywebroom.Collections.IndexItemsDesignsByItemIdCollection()
    itemsDesignsCollection.fetch
      async  : false
      url    : itemsDesignsCollection.url item_id
      success: (response)->
        console.log("items designs fetch successful: ")
        console.log(response)
    
    return itemsDesignsCollection
    
    

  setCategories: (categories) ->
    # empty out existing dropdown items
    $('#dropdown-object > .dropdown-menu').empty()
    
    
    # iterate through the category items and create a li out of each one
    _.each(categories, (category) ->
      if category.category
        $('#dropdown-object > .dropdown-menu').append('<li class=\"store-dropdown-item\"><a href=\"#\">'+_.str.capitalize(category.category)+'</a></li>');
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
  
    
    
    
    
    



  #--------------------------
  # change hover image on maouse over
  #--------------------------
  hoverStoreItem: (event) ->
    event.preventDefault()
    console.log("hover "+this.model.get('id'))
    button_preview = $.cloudinary.image 'button_preview.png',{ alt: "button preview", id: "button_preview"}
    $('#store_item_container_'+this.model.get('id')).append(button_preview)


  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffStoreItem: (event) ->
    event.preventDefault()
    console.log("hoverOff"+this.model.get('id'))
    $('#button_preview').remove()



  #*******************
  #**** Functions  - append Collection to room store page
  #*******************

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



  #*******************
  #**** Functions  - hide and show tabs
  #*******************

  #--------------------------
  # hide items tap
  #--------------------------
  hideItemsTab: ->
    $tab_item = $('[data-toggle="tab"][href="#tab_items"]')
    $tab_item.parent().removeClass('active')
    $tab_item.hide()
    $tab_body_item = $('#tab_items')
    $tab_body_item.removeClass('active')
    $tab_body_item.hide()

  #--------------------------
  # show items designs tap
  #--------------------------
  showItemsDesignsTab: ->
    $tab_item_designs = $('[data-toggle="tab"][href="#tab_items_designs"]')
    $tab_item_designs.show()
    $tab_item_designs.parent().addClass('active')
    $tab_body_item_designs = $('#tab_items_designs')
    $tab_body_item_designs.addClass('active')


  #--------------------------
  # move to the items designs
  #--------------------------

  moveToItemsDesignsTab: ->
    $tab_item = $('[data-toggle="tab"][href="#tab_items"]')
    $tab_item.parent().removeClass('active')

    $tab_body_item = $('#tab_items')
    $tab_body_item.removeClass('active')

    $tab_item_designs = $('[data-toggle="tab"][href="#tab_items_designs"]')
    $tab_item_designs.parent().addClass('active')

    $tab_body_item_designs = $('#tab_items_designs')
    $tab_body_item_designs.addClass('active')

  #*******************
  #**** Funtions -
  #*******************

  #--------------------------
  # do center the element to room that is on the center
  #--------------------------
  setItemToCenter:(itemModel) ->
    # move to the center
    console.log("center the element with the center room")
    item_location_x = parseInt(itemModel.get('x'));
    console.log(item_location_x)

    $('#xroom_items_0').attr('data-current_screen_position','0')
    $('#xroom_items_0').css({
        'left':Math.floor(-1999-item_location_x+100)
    })
    $('#xroom_items_1').attr('data-current_screen_position','1')
    $('#xroom_items_1').css({
          'left':Math.floor(0-item_location_x+100)
    })
    $('#xroom_items_2').attr('data-current_screen_position','2')
    $('#xroom_items_2').css({
          'left':Math.floor(1999-item_location_x+100)
    })
#    $(window).scrollLeft(0)
    console.log("window location"+$(window).scrollLeft())

