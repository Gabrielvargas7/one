class Mywebroom.Views.TutorialWelcomeView extends Backbone.View


  #*******************
  #**** Template
  #*******************
  template: JST['tutorial/TutorialWelcomeTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click #tutorial_welcome_btn':    'welcomeButton'

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
  welcomeButton: (e) ->

    e.preventDefault()
    e.stopPropagation()

    console.log("welcome to tutorial")


    view = new Mywebroom.Views.TutorialClickItemView()
    $("#xroom_tutorial_container").append(view.el)
    view.render()
    Mywebroom.State.set("tutorialItemClick",view)

    console.log('Kill: ', this);
    this.unbind(); # Unbind all local event bindings
    this.remove(); # Remove view from DOM
    delete this.$el; # Delete the jQuery wrapped object variable
    delete this.el;









