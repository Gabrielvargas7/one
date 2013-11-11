class Mywebroom.Views.TutorialWelcomeView extends Backbone.View


  #*******************
  #**** Template
  #*******************
  template: JST['tutorial/TutorialWelcomeTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click #welcome_button':    'welcomeButton'

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








