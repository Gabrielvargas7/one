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
    'click .store_container_item_designs':'clickStoreItemDesigns'
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
#    console.log("Store Menu Items View "+@model.get('id'))
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
    console.log("click Store Menu item design View "+@model.get('id'))
    console.log(" item id "+@model.get('item_id'))

    itemId =@model.get('item_id')
    itemDesignId =@model.get('id')
    imageName = @model.get('image_name').url
    imageNameHover = @model.get('image_name_hover').url

    $('[data-room_item_id='+itemId+']').attr("src", imageName)
    $('[data-room_item_id='+itemId+']').attr("data-room_item_design_id",itemDesignId)
    $('[data-room_item_id='+itemId+']').attr("data-room_item_design",'new')
    $('[data-room_item_id='+itemId+']').hover (->  $(this).attr("src",imageNameHover)), -> $(this).attr("src",imageName)

    # move to the center
    console.log($('[data-room_item_id='+itemId+']').offset())
    item_position  = $('[data-room_item_id='+itemId+']').offset()
    console.log(item_position.left)
    console.log(item_position.top)
    $('body').scrollLeft(item_position.left);


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



  #*******************
  #**** Funtions - move to the center
  #*******************



