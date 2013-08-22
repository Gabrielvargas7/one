class Mywebroom.Views.RoomHeaderView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

  #*******************
  #**** Templeate
  #*******************

  template: JST['rooms/RoomHeaderTemplate']

  #*******************
  #**** Events
  #*******************

  events:{

  }
#  **********************
#  *** function showProfile
#  **********************

  initialize: ->


  #*******************
  #**** Render
  #*******************
  render: ->
    console.log("Adding the RoomHeaderView ")
    $(@el).append(@template())
    this



  #*******************
  #**** Funtions  Start Room
  #*******************

