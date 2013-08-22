class Mywebroom.Views.RoomUserItemsDesignsView  extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


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
    this

  #*******************
  #**** Funtions
  #*******************

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
    dataID= this.options.user_item_design.id
    $('[data-id='+dataID+']').attr('src',this.options.user_item_design.image_name_hover.url)


  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffItem: (event) ->
    event.preventDefault()
    dataID= this.options.user_item_design.id
    $('[data-id='+dataID+']').attr('src',this.options.user_item_design.image_name.url)






