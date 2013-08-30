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
    'click img.store_item':'clickStoreItem'
    'mouseenter img.store_item':'hoverStoreItem'
    'mouseleave img.store_item':'hoverOffStoreItem'

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



  #--------------------------
  # change hover image on maouse over
  #--------------------------
  hoverStoreItem: (event) ->
    event.preventDefault()
    console.log("hover")



  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffStoreItem: (event) ->
    event.preventDefault()
    console.log("hoverOff")






