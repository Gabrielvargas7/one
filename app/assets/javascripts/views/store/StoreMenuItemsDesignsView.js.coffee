class Mywebroom.Views.StoreMenuItemsDesignsView  extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

  tagName: 'li'
  #*******************
  #**** Templeate
  #*******************
  template: JST['store/StoreMenuItemsDesignsTemplate']


  #*******************
  #**** Events
  #*******************
  events:
    'click .store_container_item_designs'     :'clickStoreItemDesigns'
    'mouseenter .store_container_item_designs':'hoverStoreItemDesigns'
    'mouseleave .store_container_item_designs':'hoverOffStoreItemDesigns'


  #*******************
  #**** Initialize
  #*******************
  initialize: ->

    #*******************
    #**** Render
    #*******************
  render: ->
    $(@el).append(@template(item_designs:@model))
    this


  #*******************
  #**** Funtions - events
  #*******************

  #--------------------------
  # do something on click
  #--------------------------
  clickStoreItemDesigns: (event) ->
     
    event.preventDefault()
    
  
    # Type of object
    itemId       = @model.get("item_id")
    
    # Item Design ID
    itemDesignId = @model.get("id")
    
    # The URL
    url          = @model.get("image_name").url
    
    # The URL for hovering
    urlHover     = @model.get("image_name_hover").url
    
    
    
    
    
    
    console.log("***** CLICK STORE ITEM DESIGN:\t", itemDesignId, " *********")
    
    
    
    
    
    
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
    unless $("[data-room_item_id=" + itemId + "]").attr("data-room-hide") is "yes"
      $('#xroom_store_remove').show()
    
    
    
    
    
    # Change the properties of the design in the DOM
    $('[data-room_item_id=' + itemId + ']').attr("src", url)
    $('[data-room_item_id=' + itemId + ']').attr("data-room_item_design_id", itemDesignId)
    $('[data-room_item_id=' + itemId + ']').attr("data-room_item_design", "new")
    $('[data-room_item_id=' + itemId + ']').hover (->  $(this).attr("src", urlHover)), -> $(this).attr("src", url)


    ###
    Find the design that was clicked and
    create a reference to it's container element
    ###
    $activeDesign = $("[data-room_item_id=" + itemId + "]")
    

    # Save this object to our state model
    Mywebroom.State.set("$activeDesign", $activeDesign)
    
        
        
    # Is this a hidden object?
    activeDesignIsHidden = $activeDesign.data().roomHide
    Mywebroom.State.set("activeDesignIsHidden", activeDesignIsHidden)
    
    
    # Show
    $activeDesign.show()


    



  #--------------------------
  # change hover image on mouse over
  #--------------------------
  hoverStoreItemDesigns: (event) ->
    event.preventDefault()
    #console.log("hover " + this.model.get('id'))
    buttonPreview = $.cloudinary.image 'button_preview.png',{ alt: "button preview", id: "button_preview"}
    $('#store_item_designs_container_' + @model.get('id')).append(buttonPreview)


  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffStoreItemDesigns: (event) ->
    event.preventDefault()
    #console.log("hoverOff" + this.model.get('id'))
    $('#button_preview').remove()
