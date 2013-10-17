class Mywebroom.Views.RoomScrollRightView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Template
  #*******************
  template: JST['rooms/RoomScrollRightTemplate']

  #*******************
  #**** Events
  #*******************

  events: {
    'mouseenter .room_scroll_right': 'hoverRoomScrollRight'
    'mouseleave .room_scroll_right': 'hoverOffRoomScrollRight'
  }

  #*******************
  #**** Initialize
  #*******************
  initialize: ->

    #*******************
    #**** Render
    #*******************
  render: ->
    $(@el).append(@template())
    this


  #*******************
  #**** Functions  - events
  #*******************

  #--------------------------
  # change hover image on maouse over
  #--------------------------
  hoverRoomScrollRight: (event) ->
    event.preventDefault()
    #console.log("hover scroll right ")
    @loop_interval = setInterval(this.moveToTheRight, 1)

  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffRoomScrollRight: (event) ->
    event.preventDefault()
    #console.log("hover Off")
    window.clearInterval(@loop_interval)
    #console.log($(window).scrollLeft())



  #*******************
  #**** Functions  - moving to the left
  #*******************

  moveToTheRight:->
    $(window).scrollLeft(0)

    $('#xroom_items_0').css({
      'left':Math.floor($("#xroom_items_0").offset().left-5)
    })

    $('#xroom_items_1').css({
      'left':Math.floor($("#xroom_items_1").offset().left-5)
    })

    $('#xroom_items_2').css({
      'left':Math.floor($("#xroom_items_2").offset().left-5)
    })

    if $("[data-current_screen_position='1']").offset().left < -1

      pos0 = $("[data-current_screen_position='0']").attr('id')
      pos1 = $("[data-current_screen_position='1']").attr('id')
      pos2 = $("[data-current_screen_position='2']").attr('id')

      initial_position = $('#'+pos2).offset().left+2200

      $('#' + pos0).attr('data-current_screen_position','2')
      $('#' + pos1).attr('data-current_screen_position','0')
      $('#' + pos2).attr('data-current_screen_position','1')
      $('#' + pos0).css({
        'left':initial_position
      })
