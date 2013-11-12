class Mywebroom.Views.TutorialOpenStoreView extends Backbone.View


  #*******************
  #**** Template
  #*******************
  template: JST['tutorial/TutorialOpenStoreTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click #tutorial_open_store_btn':    'tutorialOpenStore'

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
  tutorialOpenStore: (e) ->

    e.preventDefault()
    e.stopPropagation()

    console.log("tutorial Open Store")
    view = new Mywebroom.Views.TutorialEditorOpenView()
    $("#xroom_tutorial_container").append(view.el)
    view.render()


    console.log('Kill: ', this);
    this.unbind(); # Unbind all local event bindings
    this.remove(); # Remove view from DOM
    delete this.$el; # Delete the jQuery wrapped object variable
    delete this.el;









