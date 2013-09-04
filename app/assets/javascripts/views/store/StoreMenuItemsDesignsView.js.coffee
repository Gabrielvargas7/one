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
  #**** Funtions
  #*******************

  #--------------------------
  # do something on click
  #--------------------------
  clickStoreItemDesigns: (event) ->
    event.preventDefault()
    console.log("click Store Menu item design View "+@model.get('id'))
    console.log(" item id "+@model.get('item_id'))
    image_name = @model.get('image_name').url
    console.log(image_name)
#    $('current_background').attr("src", image_name);
#    $('#current_background').attr("data-theme_id", @model.get('id'));





  #--------------------------
  # change hover image on maouse over
  #--------------------------
  hoverStoreItemDesigns: (event) ->
    event.preventDefault()
    console.log("hover "+this.model.get('id'))
    button_preview = $.cloudinary.image 'button_preview.png',{ alt: "button preview", id: "button_preview"}
    $('#store_item_designs_container_'+this.model.get('id')).append(button_preview)


  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffStoreItemDesigns: (event) ->
    event.preventDefault()
    console.log("hoverOff"+this.model.get('id'))
    $('#button_preview').remove()






