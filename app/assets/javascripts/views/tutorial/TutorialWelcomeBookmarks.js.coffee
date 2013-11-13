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

    console.log("tutorial Bookmark Discover")
    view = new Mywebroom.Views.TutorialBookmarksDiscoverView()
    $("#xroom_tutorial_container").append(view.el)
    view.render()


    console.log('Kill: ', this);
    this.unbind(); # Unbind all local event bindings
    this.remove(); # Remove view from DOM
    delete this.$el; # Delete the jQuery wrapped object variable
    delete this.el;





