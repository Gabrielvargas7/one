class Mywebroom.Views.TutorialEditorOpenView extends Backbone.View


  #*******************
  #**** Template
  #*******************
  template: JST['tutorial/TutorialEditorOpenTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click #tutorial_editor_open_btn':    'tutorialEditorOpenBtn'

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
  tutorialEditorOpenBtn: (e) ->

    e.preventDefault()
    e.stopPropagation()

    console.log("tutorial editor open")

#    view = new Mywebroom.Views.TutorialOpenStoreView()
#    $("#xroom_tutorial_container").append(view.el)
#    view.render()


    console.log('Kill: ', this);
    this.unbind(); # Unbind all local event bindings
    this.remove(); # Remove view from DOM
    delete this.$el; # Delete the jQuery wrapped object variable
    delete this.el;




