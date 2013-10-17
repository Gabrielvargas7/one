class Mywebroom.Views.SearchView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************
  tagName:'div'
  className:'header_search_wrapper'


  #*******************
  #**** Templeate
  #*******************

  template: JST['search/SearchTemplate']



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
    #console.log("Adding the SearchView with model:")
    $(@el).append(@template())
    this
