class Mywebroom.Views.StorePageView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Templeate
  #*******************


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
    console.log("storepage view: ")
    console.log(@model)
    alert("user id: "+@model.get('user').id)
    $(@el).append()
    this


#*******************
#**** Functions  Initialize Room
#*******************

