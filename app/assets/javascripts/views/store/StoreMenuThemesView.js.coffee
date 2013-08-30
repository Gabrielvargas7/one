class Mywebroom.Views.StoreMenuThemesView  extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

  tagName: 'li'
  #*******************
  #**** Templeate
  #*******************
  template: JST['store/StoreMenuThemesTemplate']


  #*******************
  #**** Events
  #*******************
  events:
    'click .store_container':'clickStoreTheme'
    'mouseenter .store_container':'hoverStoreTheme'
    'mouseleave .store_container':'hoverOffStoreTheme'

  #*******************
  #**** Initialize
  #*******************
  initialize: ->



  #*******************
  #**** Render
  #*******************
  render: ->

    console.log("Store Menu Theme View "+@model.get('id'))
    $(@el).append(@template(theme:@model))
    this


  #*******************
  #**** Funtions
  #*******************

  #--------------------------
  # do something on click
  #--------------------------
  clickStoreTheme: (event) ->
    event.preventDefault()
    console.log("click")



  #--------------------------
  # change hover image on maouse over
  #--------------------------
  hoverStoreTheme: (event) ->
    event.preventDefault()
    console.log("hover "+this.model.get('id'))
    button_preview = $.cloudinary.image 'button_preview.png',{ alt: "button preview", id: "button_preview"}
    $('#store_theme_container_'+this.model.get('id')).append(button_preview)




  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffStoreTheme: (event) ->
    event.preventDefault()
    console.log("hoverOff"+this.model.get('id'))
    $('#button_preview').remove()






