###
This view represents a clickable design in the room
###
class Mywebroom.Views.RoomDesignView  extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Templeate
  #*******************
  template: JST['rooms/RoomDesignTemplate']


  #*******************
  #**** Events
  #*******************
  events:
    'click img.room_design':      'clickItem'

  #*******************
  #**** Initialize
  #*******************
  initialize: ->

    @design = @options.design
    #*******************
    #**** Render
    #*******************
  render: ->

    $(@el).append(@template(design: @design))
    

    y = @design.y.toString() + 'px'
    x = @design.x.toString() + 'px'
    z = @design.z.toString()
    
    width = @design.width.toString() + 'px'
    container = ".room_design_container_" + @design.item_id.toString()

    $(container).css({
      'position': 'absolute'
      'width':    width
      'left':     x
      'top':      y
      'z-index':  z
    })
     

    this

  #*******************
  #**** Funtions
  #*******************

  


  #--------------------------
  # do something on click
  #--------------------------
  clickItem: (event) ->
    event.preventDefault()

    
    @hideAndShowBookmarks(@design.item_id)
    @displayBookmark()

    if @design.clickable is "yes"
      bookmarksView = new Mywebroom.Views.BookmarksView({items_name:@design.items_name,user_item_design: @design.item_id, user: Mywebroom.State.get("roomUser").get("id") })
      
      self = this
      $('#room_bookmark_item_id_container_' + @design.item_id).append(bookmarksView.el)
      bookmarksView.render()





 
  #--------------------------
  # hide bookmarks when is not this item
  #--------------------------
  hideAndShowBookmarks:(bookmark_item_id) ->
    designs = Mywebroom.State.get("roomDesigns")
    

    length = designs.length
    i = 0
    while i < length
      if bookmark_item_id is designs[i].item_id
        $('#room_bookmark_item_id_container_' + designs[i].item_id).show()
      else
        $('#room_bookmark_item_id_container_' + designs[i].item_id).hide()
      i += 1

  #--------------------------
  # hide store and profile pages
  #--------------------------
  displayBookmark: ->
    $('#xroom_store_menu_save_cancel_remove').hide()
    $('#xroom_storepage').hide()
    $('#xroom_profile').hide()
    $('#xroom_bookmarks').show()

