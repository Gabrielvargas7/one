class Mywebroom.Views.TutorialCongratulationsBookmarksView extends Backbone.View


  #*******************
  #**** Template
  #*******************
  template: JST['tutorial/TutorialCongratulationsBookmarksTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click #tutorial_congratulations_bookmarks_btn':    'tutorialCongratulationsBookmarksBtn'

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
  tutorialCongratulationsBookmarksBtn: (e) ->

    e.preventDefault()
    e.stopPropagation()

    $('#xroom_bookmarks').hide()
    $('#xroom_profile').show()

    #remove the view
    bookmarksView = Mywebroom.State.get("tutorialBookmarkView")
    bookmarksView.closeView()

    user_id  = Mywebroom.State.get("signInUser").get("id")
    tutorial_step = 8
    # save the new step on the tutorial
    Mywebroom.Helpers.TutorialHelper.saveTutorialStep(user_id,tutorial_step)

    console.log("tutorial congratulation bookmark")
    view = new Mywebroom.Views.TutorialWelcomeProfileView()
    $("#xroom_tutorial_container").append(view.el)
    view.render()


    console.log('Kill: ', this);
    this.unbind(); # Unbind all local event bindings
    this.remove(); # Remove view from DOM
    delete this.$el; # Delete the jQuery wrapped object variable
    delete this.el;





