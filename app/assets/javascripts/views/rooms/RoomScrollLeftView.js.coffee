class Mywebroom.Views.RoomScrollLeftView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Templeate
  #*******************
  template: JST['rooms/RoomScrollLeftTemplate']

  #*******************
  #**** Events
  #*******************

  events:{
    'mouseenter .room_scroll_left':'hoverRoomScrollLeft'
    'mouseleave .room_scroll_left':'hoverOffRoomScrollLeft'

  }

  #*******************
  #**** Initialize
  #*******************
  initialize: ->

    #*******************
    #**** Render
    #*******************
  render: ->
    console.log("storepage view: ")
    $(@el).append(@template())


    this




  #*******************
  #**** Functions  - events
  #*******************

  #--------------------------
  # change hover image on maouse over
  #--------------------------
  hoverRoomScrollLeft: (event) ->
    event.preventDefault()
    console.log("hover")


  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffRoomScrollLeft: (event) ->
    event.preventDefault()
    console.log("hover Off")
