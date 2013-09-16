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
    'click .store_container_item':'clickStoreItem'
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
#    console.log("Store Menu Items View "+@model.get('id'))
    $(@el).append(@template(item:@model))
    this


  #*******************
  #**** Funtions  -Collection
  #*******************


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


  #*******************
  #**** Funtions  -evens
  #*******************

  #--------------------------
  # do something on click
  #--------------------------
  clickStoreItem: (event) ->
    event.preventDefault()
    console.log("click")

#    this.hideItemsTab()
#    this.showItemsDesignsTab()
    this.moveToItemsDesignsTab()
    itemsDesignsCollection = this.getItemsDesignsCollection(this.model.get('id'))
    this.appendItemsDesignsEntry(itemsDesignsCollection)
    this.setItemToCenter(this.model)



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
        'left':Math.floor(0+300-item_location_x+300)
    })
    $('#xroom_items_1').attr('data-current_screen_position','1')
    $('#xroom_items_1').css({
          'left':Math.floor(1999+300-item_location_x+300)
    })
    $('#xroom_items_2').attr('data-current_screen_position','2')
    $('#xroom_items_2').css({
          'left':Math.floor(3999+300-item_location_x+300)
    })
    $(window).scrollLeft(2300)
    console.log($(window).scrollLeft())

