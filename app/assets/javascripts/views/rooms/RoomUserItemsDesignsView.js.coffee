class Mywebroom.Views.RoomUserItemsDesignsView  extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

#  el: '.xroom_item_designs'

  #*******************
  #**** Templeate
  #*******************
  template: JST['rooms/RoomUserItemsDesignsTemplate']


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
#    console.log(this.options.user)
    $(@el).append(@template(user_item_design:this.options.user_item_design))
    this.setHoverOffOnImages()

    this


  #*******************
  #**** Funtions
  #*******************

  #--------------------------
  # set hover on off images by jquery
  #--------------------------
  setHoverOffOnImages: ->
    itemId= this.options.user_item_design.item_id
    imageNameHover = this.options.user_item_design.image_name_hover.url
    imageName = this.options.user_item_design.image_name.url
    $('[data-room_item_id='+itemId+']').hover (->  $(this).attr("src",imageNameHover)), -> $(this).attr("src",imageName)


  #--------------------------
  # do something on click
  #--------------------------
  clickItem: (event) ->
    event.preventDefault()
    console.log("You clicked an object: "+this.options.user_item_design)
    console.log(this.options.user_item_design)
    console.log(this.options.user)
    bookmarksView = new Mywebroom.Views.BookmarksView({user_item_design:this.options.user_item_design,user:this.options.user})
    $('#xroom_bookmarks').append(bookmarksView.el)
    bookmarksView.render()

  #--------------------------
  # change hover image on maouse over
  #--------------------------
  hoverItem: (event) ->
    event.preventDefault()
    console.log("hover")



  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffItem: (event) ->
    event.preventDefault()
    console.log("hover Off")






