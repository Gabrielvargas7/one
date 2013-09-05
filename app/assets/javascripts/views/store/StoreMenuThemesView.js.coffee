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
    'click .store_container_theme':'clickStoreTheme'
    'mouseenter .store_container_theme':'hoverStoreTheme'
    'mouseleave .store_container_theme':'hoverOffStoreTheme'

  #*******************
  #**** Initialize
  #*******************
  initialize: ->



  #*******************
  #**** Render
  #*******************
  render: ->

#    console.log("Store Menu Theme View "+@model.get('id'))
    $(@el).append(@template(theme:@model))
    this


  #*******************
  #**** Funtions  -events
  #*******************

  #--------------------------
  # do something on click
  #--------------------------
  clickStoreTheme: (event) ->
    event.preventDefault()
    console.log("click Store Menu Theme View "+@model.get('id'))
    imageName = @model.get('image_name').url
    console.log(imageName)
    $('.current_background').attr("src", imageName);
    $('.current_background').attr("data-theme_id", @model.get('id'));


  #--------------------------
  # change hover image on maouse over
  #--------------------------
  hoverStoreTheme: (event) ->
    event.preventDefault()
    console.log("hover "+this.model.get('id'))
    buttonPreview = $.cloudinary.image 'button_preview.png',{ alt: "button preview", id: "button_preview"}
    $('#store_theme_container_'+this.model.get('id')).append(buttonPreview)



  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffStoreTheme: (event) ->
    event.preventDefault()
    console.log("hoverOff"+this.model.get('id'))
    $('#button_preview').remove()








