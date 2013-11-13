class Mywebroom.Views.TutorialWelcomeProfileView extends Backbone.View


  #*******************
  #**** Template
  #*******************
  template: JST['tutorial/TutorialWelcomeProfileTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click #tutorial_welcome_profile_btn':    'tutorialWelcomeProfileBtn'

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
  tutorialWelcomeProfileBtn: (e) ->

    e.preventDefault()
    e.stopPropagation()

    console.log("tutorial welcome profile btn")
    view = new Mywebroom.Views.TutorialFriendsProfileView()
    $("#xroom_tutorial_container").append(view.el)
    view.render()


    console.log('Kill: ', this);
    this.unbind(); # Unbind all local event bindings
    this.remove(); # Remove view from DOM
    delete this.$el; # Delete the jQuery wrapped object variable
    delete this.el;



