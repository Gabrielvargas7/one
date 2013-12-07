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

    _gaq.push(['_trackEvent', 'tutorial','click_btn','welcome']);
    #console.log("welcome to tutorial")



    #    signInUser  = Mywebroom.State.get("signInUser").get("id")
    #    user_id = signInUser.get('id')

    user_id  = Mywebroom.State.get("signInUser").get("id")
    tutorial_step = 2
    #console.log("user id "+user_id+" and tutorial step "+tutorial_step)
    # save the new step on the tutorial
    Mywebroom.Helpers.TutorialHelper.saveTutorialStep(user_id,tutorial_step)



    view = new Mywebroom.Views.TutorialClickItemView()
    $("#xroom_tutorial_container").append(view.el)
    view.render()
    Mywebroom.State.set("tutorialItemClick",view)

    #console.log('Kill: ', this)
    this.unbind() # Unbind all local event bindings
    this.remove() # Remove view from DOM
    delete this.$el # Delete the jQuery wrapped object variable
    delete this.el









