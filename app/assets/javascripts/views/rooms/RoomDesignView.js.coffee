###
This view represents a clickable design in the room
###
class Mywebroom.Views.RoomDesignView  extends Backbone.View

  #*******************
  #**** Template
  #*******************
  template: JST['rooms/RoomDesignTemplate']


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

    #EXCEPTION: Portrait:
    if item_id is 21
      #add the profile pic to this. 
      #pic should position absolutely in div, with z-index z+1, left- 20px, top- 20px
      profilePic = Mywebroom.State.get('roomData').get('user_photos').image_name.url
      this.$(container).append("<img id=room_design_portrait_pic src='"+profilePic+"' style='z-index:"+ (z-1)+"'>")

    this
