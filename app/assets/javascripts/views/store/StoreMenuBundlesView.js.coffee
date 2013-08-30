class Mywebroom.Views.StoreMenuBundlesView  extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

  tagName: 'li'
  #*******************
  #**** Templeate
  #*******************
  template: JST['store/StoreMenuBundlesTemplate']


  #*******************
  #**** Events
  #*******************
  events:
    'click .store_container':'clickStoreBundle'
    'mouseenter .store_container':'hoverStoreBundle'
    'mouseleave .store_container':'hoverOffStoreBundle'

  #*******************
  #**** Initialize
  #*******************
  initialize: ->



    #*******************
    #**** Render
    #*******************
  render: ->

    console.log("Store Menu Bundle View "+@model.get('id'))
    $(@el).append(@template(bundle:@model))
    this


  #*******************
  #**** Funtions
  #*******************

  #--------------------------
  # do something on click
  #--------------------------
  clickStoreBundle: (event) ->
    event.preventDefault()
    console.log("click")



  #--------------------------
  # change hover image on maouse over
  #--------------------------
  hoverStoreBundle: (event) ->
    event.preventDefault()
    console.log("hover "+this.model.get('id'))
    button_preview = $.cloudinary.image 'button_preview.png',{ alt: "button preview", id: "button_preview"}
    $('#store_bundle_container_'+this.model.get('id')).append(button_preview)




  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffStoreBundle: (event) ->
    event.preventDefault()
    console.log("hoverOff"+this.model.get('id'))
    $('#button_preview').remove()







