class Mywebroom.Views.TutorialBookmarksDiscoverView extends Backbone.View


  #*******************
  #**** Template
  #*******************
  template: JST['tutorial/TutorialBookmarksDiscoverTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click #tutorial_bookmarks_discover_btn':    'tutorialBookmarksDiscoverBtn'

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
  tutorialBookmarksDiscoverBtn: (e) ->

    e.preventDefault()
    e.stopPropagation()

#    NO IN USE, remove any time

#    $('#xroom_bookmarks').hide()
#    $('#xroom_profile').show()
#
#    user_id  = Mywebroom.State.get("signInUser").get("id")
#    tutorial_step = 7
#    # save the new step on the tutorial
#    Mywebroom.Helpers.TutorialHelper.saveTutorialStep(user_id,tutorial_step)
#
#
#
#    console.log("tutorial Bookmark Discover btn")
#    view = new Mywebroom.Views.TutorialWelcomeProfileView()
#    $("#xroom_tutorial_container").append(view.el)
#    view.render()
#
#
#    console.log('Kill: ', this);
#    this.unbind(); # Unbind all local event bindings
#    this.remove(); # Remove view from DOM
#    delete this.$el; # Delete the jQuery wrapped object variable
#    delete this.el;


  tutorialBookmarkDicoverDestroy: ->
    #console.log('Kill: ', this);
    this.unbind(); # Unbind all local event bindings
    this.remove(); # Remove view from DOM
    delete this.$el; # Delete the jQuery wrapped object variable
    delete this.el;

