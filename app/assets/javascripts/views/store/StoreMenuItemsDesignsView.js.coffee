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
    
    
    itemId         = @model.get("item_id")
    itemDesignId   = @model.get("id")
    imageName      = @model.get("image_name").url
    imageNameHover = @model.get("image_name_hover").url
    
    
    console.log("click Store Menu item design View ", itemDesignId)
    console.log("itemId ", itemId)
    
    
    
    
    
    
    
    # Show the view with the Save, Cancel, Remove buttons
    
    # Hide the remove button
    

    

    $('[data-room_item_id='+itemId+']').attr("src", imageName)
    $('[data-room_item_id='+itemId+']').attr("data-room_item_design_id",itemDesignId)
    $('[data-room_item_id='+itemId+']').attr("data-room_item_design",'new')
    $('[data-room_item_id='+itemId+']').hover (->  $(this).attr("src",imageNameHover)), -> $(this).attr("src",imageName)



    ###
    Here's where we need to un-hide the dropdowns and populate them
    ###




  #--------------------------
  # change hover image on mouse over
  #--------------------------
  hoverStoreItemDesigns: (event) ->
    event.preventDefault()
    console.log("hover "+this.model.get('id'))
    buttonPreview = $.cloudinary.image 'button_preview.png',{ alt: "button preview", id: "button_preview"}
    $('#store_item_designs_container_'+this.model.get('id')).append(buttonPreview)


  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffStoreItemDesigns: (event) ->
    event.preventDefault()
    console.log("hoverOff"+this.model.get('id'))
    $('#button_preview').remove()
