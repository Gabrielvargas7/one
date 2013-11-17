class Mywebroom.Views.TutorialClickItemView extends Backbone.View


  #*******************
  #**** Template
  #*******************
  template: JST['tutorial/TutorialClickItemTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click #tutorial_click_item_btn':    'tutorialClickItemSkipBtn'

  }


  #*******************
  #**** Render
  #*******************
  render: ->

    # THIS VIEW
    $(@el).html(@template())

    this




  #--------------------------
  # close store page
  #--------------------------
  tutorialClickItemSkipBtn: (event) ->

    event.preventDefault()
    event.stopPropagation()

    #console.log("tutorial click item")

    view = new Mywebroom.Views.TutorialOpenStoreView()
    $("#xroom_tutorial_container").append(view.el)
    view.render()

    #console.log('Kill: ', this);
    this.unbind() # Unbind all local event bindings
    this.remove() # Remove view from DOM
    delete this.$el # Delete the jQuery wrapped object variable
    delete this.el


  tutorialClickItemDestroy: ->
    #console.log('Kill: ', this);
    this.unbind() # Unbind all local event bindings
    this.remove() # Remove view from DOM
    delete this.$el # Delete the jQuery wrapped object variable
    delete this.el









