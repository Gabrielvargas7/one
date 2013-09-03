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
  #**** Funtions
  #*******************

  #--------------------------
  # do something on click
  #--------------------------
  clickStoreItem: (event) ->
    event.preventDefault()
    console.log("click")

    this.hideItemsTab()
    this.showItemsDesignsTab()
    this.getItemsDesignsCollection(this.model.get('id'))
    this.appendItemsDesignsEntry()



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


  #--------------------------
  # get the items designs data
  #--------------------------
  getItemsDesignsCollection: (item_id) ->
    @itemsDesignsCollection = new Mywebroom.Collections.IndexItemsDesignsByItemIdCollection()
    @itemsDesignsCollection.fetch
      async:false
      url:@itemsDesignsCollection.url item_id
      success:(response) ->
        console.log("items designs fetch successful: ")
        console.log(response)

  #--------------------------
  # append items designs views
  #--------------------------

  appendItemsDesignsEntry: ->
    $("#tab_items_designs > ul").remove()

    @loop_number = 0
    @row_number = 1
    @column_number = 3

    @row_line = "<ul id='row_item_designs_"+@row_number+"'></ul>"
    this.$('#tab_items_designs').append(@row_line)

    that = this
    @itemsDesignsCollection.each (entry)  ->
      @storeMenuItemsDesignsView = new Mywebroom.Views.StoreMenuItemsDesignsView(model:entry)
      @.$('#row_item_designs_'+that.row_number).append(@storeMenuItemsDesignsView.el)
      @storeMenuItemsDesignsView.render()
      that.loop_number++

      u = that.loop_number%that.column_number
      if u == 0
        that.row_number++
        that.row_line = "<ul id='row_item_designs_"+that.row_number+"'></ul>"
        this.$('#tab_items_designs').append(that.row_line)


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

