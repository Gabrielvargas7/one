class Mywebroom.Views.SearchEntityView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

  #*******************
  #**** Templeate
  #*******************

  template: JST['search/SearchEntityTemplate']



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
    console.log("Adding the SearchEntityView with model:")
    $(@el).append(@template(entity:@model))
    this

