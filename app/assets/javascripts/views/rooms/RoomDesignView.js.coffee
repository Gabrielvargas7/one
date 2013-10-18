###
This view represents a clickable design in the room
###
class Mywebroom.Views.RoomDesignView  extends Backbone.View

  #*******************
  #**** Template
  #*******************
  template: JST['rooms/RoomDesignTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click img.room_design': 'clickItem'
  }


  #*******************
  #**** Initialize
  #*******************
  initialize: ->

    
  #*******************
  #**** Render
  #*******************
  render: ->
    
    this.$el.append(@template(design: @model.toJSON()))    


    item_id =   @model.get("item_id")
    y =         @model.get("y") + 'px'
    x =         @model.get("x") + 'px'
    z =         @model.get("z")
    width =     @model.get("width") + 'px'
    container = ".room_design_container_" + item_id


    $(container).css({
      'position': 'absolute'
      'width':    width
      'left':     x
      'top':      y
      'z-index':  z
    })
     

    this


  #--------------------------
  # do something on click
  #--------------------------
  clickItem: () ->
    
    ###
    (1) Close all bookmark containers
    (2) Show ours
    ###
    designs = Mywebroom.State.get("roomDesigns")
    length =  designs.length
    
    id = @model.get("item_id")
    
    i = 0
    while i < length
      if id is designs[i].item_id
        $('#room_bookmark_item_id_container_' + designs[i].item_id).show()
      else
        $('#room_bookmark_item_id_container_' + designs[i].item_id).hide()
      i += 1
    ###
    END
    ###
    
    
    
    
    ###
    START
    ###
    $('#xroom_store_menu_save_cancel_remove').hide()
    $('#xroom_storepage').hide()
    $('#xroom_profile').hide()
    $('#xroom_bookmarks').show()
    ###
    END
    ###
    
    
    
    
    ###
    SHOW
    ###
    if @model.get("clickable") is "yes"
      console.log("clickable")
      view = new Mywebroom.Views.BookmarksView(
        {
          items_name:       @model.get("items_name")
          user_item_design: id
          user:             Mywebroom.State.get("roomUser").get("id") 
        }
      )
      
      $('#room_bookmark_item_id_container_' + id).append(view.el)
      view.render()
    ###
    SHOW
    ###
