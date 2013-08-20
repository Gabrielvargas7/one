class Mywebroom.Views.XRoomUserItemsDesignsView  extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Templeate
  #*******************
  template: JST['rooms/XRoomUserItemsDesignsTemplate']


  #*******************
  #**** Events
  #*******************
  events:
    'click img.room_user_item_design':'clickItem'
    'mouseenter img.room_user_item_design':'hoverItem'
    'mouseleave img.room_user_item_design':'hoverOffItem'

  #*******************
  #**** Initialize
  #*******************
  initialize: ->

  #*******************
  #**** Render
  #*******************
  render: ->
    #console.log(this.options.user_item_design)
    $(@el).append(@template(user_item_design:this.options.user_item_design))
    this

  #*******************
  #**** Funtions
  #*******************

  #--------------------------
  # do something on click
  #--------------------------
  clickItem: () ->
    console.log("You clicked an object: "+this.options.user_item_design)
    console.log(this.options.user_item_design)

  #--------------------------
  # change hover image on maouse over
  #--------------------------
  hoverItem: () ->
    dataID= this.options.user_item_design.id
    $('[data-id='+dataID+']').attr('src',this.options.user_item_design.image_name_hover.url)


  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffItem: () ->
    dataID= this.options.user_item_design.id
    $('[data-id='+dataID+']').attr('src',this.options.user_item_design.image_name.url)






