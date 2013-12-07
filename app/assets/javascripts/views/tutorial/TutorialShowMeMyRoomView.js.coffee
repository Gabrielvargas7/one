class Mywebroom.Views.TutorialShowMeMyRoomView extends Backbone.View


  #*******************
  #**** Template
  #*******************
  template: JST['tutorial/TutorialShowMeMyRoomTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click #tutorial_show_me_my_room_btn':    'tutorialShowMeMyRoomBtn'


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
  tutorialShowMeMyRoomBtn: (e) ->

    e.preventDefault()
    e.stopPropagation()
    _gaq.push(['_trackEvent', 'category','action','opt_label']);

    user_id  = Mywebroom.State.get("signInUser").get("id")
    tutorial_step = 0
    # save the new step on the tutorial
    Mywebroom.Helpers.TutorialHelper.saveTutorialStep(user_id,tutorial_step)


    #console.log("tutorial Show me my Room ")

    #console.log('Kill: ', this);
    this.unbind(); # Unbind all local event bindings
    this.remove(); # Remove view from DOM
    delete this.$el; # Delete the jQuery wrapped object variable
    delete this.el;



