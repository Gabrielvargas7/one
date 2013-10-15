class Mywebroom.Views.RoomFooterView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

  #*******************
  #**** Templeate
  #*******************

  template: JST['rooms/RoomFooterTemplate']



  #*******************
  #**** Events
  #*******************

  events:{

  }


  #*******************
  #**** Initialize
  #*******************

  initialize: ->


    #*******************
    #**** Render
    #*******************
  render: ->
    #console.log("Adding the RoomFooterView with model:")
    $(@el).append(@template())
    this
