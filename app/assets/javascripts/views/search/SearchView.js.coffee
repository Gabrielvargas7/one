class Mywebroom.Views.SearchView extends Backbone.View

  #*******************
  #**** Class
  #*******************
  className:'search-wrapper'


  #*******************
  #**** Template
  #*******************
  template: JST['search/SearchTemplate']  # <-- Blank File
  

  
  
  
  #*******************
  #**** Render
  #*******************
  render: ->
    #console.log("Adding the SearchView with model:")
    $(@el).append(@template())
    this
