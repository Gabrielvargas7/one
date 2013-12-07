class Mywebroom.Views.TutorialWelcomeBookmarksView extends Backbone.View


  #*******************
  #**** Template
  #*******************
  template: JST['tutorial/TutorialWelcomeBookmarksTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click #tutorial_welcome_bookmarks_btn':    'tutorialWelcomeBookmarksBtn'

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
  tutorialWelcomeBookmarksBtn: (e) ->

    e.preventDefault()
    e.stopPropagation()

    _gaq.push(['_trackEvent', 'tutorial','click_btn','bookmark_add3']);


    user_id  = Mywebroom.State.get("signInUser").get("id")
    tutorial_step = 6
    # save the new step on the tutorial
    Mywebroom.Helpers.TutorialHelper.saveTutorialStep(user_id,tutorial_step)

    #console.log("tutorial Bookmark Discover")
    # create Bookmark Discover
    view = new Mywebroom.Views.TutorialBookmarksDiscoverView()
    $("#xroom_tutorial_container").append(view.el)
    view.render()

    # add the view on the state model
    Mywebroom.State.set("tutorialBookmarkDiscover",view)



    #console.log('Kill: ', this)
    this.unbind() # Unbind all local event bindings
    this.remove() # Remove view from DOM
    delete this.$el # Delete the jQuery wrapped object variable
    delete this.el





