class Mywebroom.Views.RoomScrollLeftView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Template
  #*******************
  template: JST['rooms/RoomScrollLeftTemplate']

  #*******************
  #**** Events
  #*******************

  events: {
    'mouseenter .room_scroll_left': 'hoverRoomScrollLeft'
    'mouseleave .room_scroll_left': 'hoverOffRoomScrollLeft'
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
  hoverRoomScrollLeft: (event) ->
    
    event.preventDefault()
    event.stopPropagation()
    
    console.log("hover scroll left ")
    
    @loop_interval = setInterval(this.moveToTheLeft, 1)


  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffRoomScrollLeft: (event) ->
    
    event.preventDefault()
    event.stopPropagation()
    
    console.log("hover Off")
    
    window.clearInterval(@loop_interval)
    
    #console.log($(window).scrollLeft())


  #*******************
  #**** Functions  - moving to the left
  #*******************     Math.floor(155.923235454541);

  moveToTheLeft: ->
    $(window).scrollLeft(0)

    $('#xroom_items_0').css({
      'left':Math.floor($("#xroom_items_0").offset().left+5)
    })

    $('#xroom_items_1').css({
      'left':Math.floor($("#xroom_items_1").offset().left+5)
    })

    $('#xroom_items_2').css({
      'left':Math.floor($("#xroom_items_2").offset().left+5)
    })


    if $("[data-current_screen_position='0']").offset().left > 1


      pos0 = $("[data-current_screen_position='0']").attr('id')
      pos1 = $("[data-current_screen_position='1']").attr('id')
      pos2 = $("[data-current_screen_position='2']").attr('id')

      initial_position = $('#'+pos0).offset().left-2200


      console.log("inside "+$('#'+pos0).offset().left)
      $('#'+pos0).attr('data-current_screen_position','1')
      $('#'+pos1).attr('data-current_screen_position','2')
      $('#'+pos2).attr('data-current_screen_position','0')
      $('#'+pos2).css({
        'left':initial_position
      })
