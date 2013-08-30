class Mywebroom.Views.StoreMenuBundlesSetView  extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

  tagName: 'li'
  #*******************
  #**** Templeate
  #*******************
  template: JST['store/StoreMenuBundlesSetTemplate']


  #*******************
  #**** Events
  #*******************
  events:
    'click .store_container':'clickStoreBundleSet'
    'mouseenter .store_container':'hoverStoreBundleSet'
    'mouseleave .store_container':'hoverOffStoreBundleSet'

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
  clickStoreBundleSet: (event) ->
    event.preventDefault()
    console.log("click")



  #--------------------------
  # change hover image on maouse over
  #--------------------------
  hoverStoreBundleSet: (event) ->
    event.preventDefault()
    console.log("hover "+this.model.get('id'))
    button_preview = $.cloudinary.image 'button_preview.png',{ alt: "button preview", id: "button_preview"}
    $('#store_bundle_set_container_'+this.model.get('id')).append(button_preview)





  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffStoreBundleSet: (event) ->
    event.preventDefault()
    console.log("hoverOff"+this.model.get('id'))
    $('#button_preview').remove()







