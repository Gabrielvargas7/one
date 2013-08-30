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
    'click .store_container':'clickStoreItem'
    'mouseenter .store_container':'hoverStoreItem'
    'mouseleave .store_container':'hoverOffStoreItem'


  #*******************
  #**** Initialize
  #*******************
  initialize: ->

  #*******************
  #**** Render
  #*******************
  render: ->
    console.log("Store Menu Items View "+@model.get('id'))
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
    console.log(this.model.get('id'))
#    $('[data-toggle="tab"][href="#tab_items"]').css.display = 'none'



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






