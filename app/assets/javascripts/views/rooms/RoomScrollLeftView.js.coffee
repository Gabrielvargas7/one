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
    
    #console.log("hover scroll left2 ")

#    this.moveToTheLeft()

    @loop_interval = setInterval(this.moveToTheLeft, 20)
    #console.log(@loop_interval)


  #--------------------------
  # change normal image on hover
  #--------------------------
  hoverOffRoomScrollLeft: (event) ->
    
    event.preventDefault()
    event.stopPropagation()
    
    #console.log("hover Off")
    #console.log(@loop_interval)
    window.clearInterval(@loop_interval)
#    console.log($(window).scrollLeft())


  #*******************
  #**** Functions  - moving to the left
  #*******************     Math.floor(155.923235454541);

  moveToTheLeft: ->
    $(window).scrollLeft(0)

    @room0 = Mywebroom.State.get('room0')
    position0 = @room0.position + 10;
    @room0.position = position0


    @room1 = Mywebroom.State.get('room1')
    position1 = @room1.position + 10;
    @room1.position = position1


    @room2 = Mywebroom.State.get('room2')
    position2 = @room2.position + 10;
    @room2.position = position2


    $(@room0.id).css({

      'left':@room0.position

    })

    $(@room1.id).css({
      'left':@room1.position
    })

    $(@room2.id).css({
      'left':@room2.position
    })



    if ((@room0.screen_position == 0  and @room0.position >= 0) or
       (@room1.screen_position == 0  and @room1.position >= 0) or
       (@room2.screen_position == 0  and @room2.position >= 0))

        if @room0.screen_position == 0


          @room0.screen_position = 1
          @room1.screen_position = 2
          @room2.screen_position = 0

          initial_position = @room0.position-2200
          @room2.position = initial_position
          $(@room2.id).css({'left':initial_position})
          #console.log("id room2 "+@room2.id)

        else if @room1.screen_position == 0

                @room1.screen_position = 1
                @room2.screen_position = 2
                @room0.screen_position = 0

                initial_position = @room1.position-2200
                @room0.position = initial_position
                $(@room0.id).css({'left':initial_position})
                #console.log("id room0 "+@room0.id)

             else
                @room2.screen_position = 1
                @room0.screen_position = 2
                @room1.screen_position = 0
                initial_position = @room2.position-2200
                @room1.position = initial_position
                $(@room1.id).css({'left':initial_position})
                #console.log("id room1 "+@room1.id)

    Mywebroom.State.set('room0',@room0)
    Mywebroom.State.set('room1',@room1)
    Mywebroom.State.set('room2',@room2)
    #console.log("p0")
    #console.log(@room0)
    #console.log("p1")
    #console.log(@room1)
    #console.log("p2")
    #console.log(@room2)




#
#    else if (@room1.screen_position == 0  and @room1.position >= 0)
#            console.log("room1 ")
#            console.log(@room1.screen_position)
#            console.log(@room1.position)
#
#
#
#         else if (@room2.screen_position == 0  and @room2.position >= 0)
#                  console.log("room2 ")
#                  console.log(@room2.screen_position)
#                  console.log(@room2.position)



#    if $("[data-current_screen_position='0']").offset().left >= 0
#
#
#      pos0 = $("[data-current_screen_position='0']").attr('id')
#      pos1 = $("[data-current_screen_position='1']").attr('id')
#      pos2 = $("[data-current_screen_position='2']").attr('id')
#
#
##      initial_position = $('#'+pos0).offset().left-2200
#
#
#      console.log("inside "+$('#'+pos0).offset().left)
#      $('#'+pos0).attr('data-current_screen_position','1')
#      $('#'+pos1).attr('data-current_screen_position','2')
#      $('#'+pos2).attr('data-current_screen_position','0')

#      $('#'+pos2).css({
#        'left':initial_position
#      })

