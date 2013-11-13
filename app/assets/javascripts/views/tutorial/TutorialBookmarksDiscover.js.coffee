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

    console.log("tutorial Bookmark Discover btn")
    view = new Mywebroom.Views.TutorialWelcomeProfileView()
    $("#xroom_tutorial_container").append(view.el)
    view.render()


    console.log('Kill: ', this);
    this.unbind(); # Unbind all local event bindings
    this.remove(); # Remove view from DOM
    delete this.$el; # Delete the jQuery wrapped object variable
    delete this.el;


