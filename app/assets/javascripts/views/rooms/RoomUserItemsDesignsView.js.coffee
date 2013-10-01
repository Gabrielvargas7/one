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
    'click img.room_user_item_design'     : 'clickItem'
    'mouseenter img.room_user_item_design': 'hoverItem'
    'mouseleave img.room_user_item_design': 'hoverOffItem'

  #*******************
  #**** Initialize
  #*******************
  initialize: ->

    @design = @options.design
    #*******************
    #**** Render
    #*******************
  render: ->

    $(@el).append(@template(user_item_design: @design))
    this.setHoverOffOnImages()

    y = @design.y.toString() + 'px'
    x = @design.x.toString() + 'px'
    z = @design.z.toString()
    
    width = @design.width.toString() + 'px'
    id_room_item_designs_container = ".room_item_designs_container_" + @design.item_id.toString()

    $(id_room_item_designs_container).css({
      'position': 'absolute',
      'width':width,
      'left':x,
      'top':y,
      'z-index':z
    })

    this

  #*******************
  #**** Funtions
  #*******************

  #--------------------------
  # set hover on off images by jquery
  #--------------------------
  setHoverOffOnImages: ->

    if @design.clickable is "yes"
      itemId = @design.item_id
      imageNameHover = @design.image_name_hover.url
      imageName = @design.image_name.url
      $('[data-room_item_id=' + itemId + ']').hover (->  $(this).attr("src", imageNameHover)), -> $(this).attr("src", imageName)


  #--------------------------
  # do something on click
  #--------------------------
  clickItem: (event) ->
    event.preventDefault()
    this.hideAndShowBookmarks(this.options.user_item_design.item_id)
    this.displayBookmark()

    if this.options.user_item_design.clickable == 'yes'
      bookmarksView = new Mywebroom.Views.BookmarksView({user_item_design:this.options.user_item_design.item_id,user:this.options.user.id})
      self= this
#      bookmarksView.on('dataForBrowseMode',((event)-> this.trigger('dataForBrowseMode2',{model:event.model})) ,self)

#      $('#xroom_bookmarks').append(bookmarksView.el)
      $('#room_bookmark_item_id_container_'+this.options.user_item_design.item_id).append(bookmarksView.el)
      bookmarksView.render()

  #--------------------------
  # change hover image on maouse over
  #--------------------------
  hoverItem: (event) ->
    event.preventDefault()



  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffItem: (event) ->
    event.preventDefault()


  #--------------------------
  # hide bookmarks when is not this item
  #--------------------------
  hideAndShowBookmarks:(bookmark_item_id) ->
    designs = Mywebroom.State.get("roomDesigns")
    

    length = designs.length
    i = 0
    while i < length
      if bookmark_item_id is designs[i].item_id
        $('#room_bookmark_item_id_container_' + designs[i].item_id).show();
      else
        $('#room_bookmark_item_id_container_' + designs[i].item_id).hide();
      i++

  #--------------------------
  # hide store and profile pages
  #--------------------------
  displayBookmark: ->
    $('#xroom_store_menu_save_cancel_remove').hide()
    $('#xroom_storepage').hide()
    $('#xroom_profile').hide()
    $('#xroom_bookmarks').show()

