class Mywebroom.Views.TutorialEditorOpenView extends Backbone.View


  #*******************
  #**** Template
  #*******************
  template: JST['tutorial/TutorialEditorOpenTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click #tutorial_editor_open_btn':    'tutorialEditorOpenBtn'

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
  tutorialEditorOpenBtn: (e) ->

    e.preventDefault()
    e.stopPropagation()
    _gaq.push(['_trackEvent', 'category','action','opt_label']);


    # Hide the Save, Cancel, Remove View
    $('#xroom_store_menu_save_cancel_remove').hide()

    # Hide the store
    Mywebroom.Helpers.hideStore()

    Mywebroom.Helpers.StoreSaveCancelRemoveHelper.saveNewItems()


    user_id  = Mywebroom.State.get("signInUser").get("id")
    tutorial_step = 5
    # save the new step on the tutorial
    Mywebroom.Helpers.TutorialHelper.saveTutorialStep(user_id,tutorial_step)




    #Open bookmarks discovery
    itemId = Mywebroom.State.get("tutorialItem")

    bookmarksView = new Mywebroom.Views.BookmarksView
      items_name: Mywebroom.Helpers.getItemNameOfItemId(parseInt(itemId))
      item_id: itemId
      user: Mywebroom.State.get("roomUser").get("id")


    $('#room_bookmark_item_id_container_' + itemId).append(bookmarksView.el)
    bookmarksView.render()

    $('#room_bookmark_item_id_container_' + itemId).show()
    $('#xroom_bookmarks').show()
    bookmarksView.renderDiscover()
    Mywebroom.State.set("tutorialBookmarkView",bookmarksView)

    #Turn off preview mode event
    bookmarksView.detachClicksTutorial()





    #console.log("tutorial editor open")
    # create Bookmark Welcome
    view = new Mywebroom.Views.TutorialWelcomeBookmarksView()
    $("#xroom_tutorial_container").append(view.el)
    view.render()



    #console.log('Kill: ', this)
    this.unbind() # Unbind all local event bindings
    this.remove() # Remove view from DOM
    delete this.$el # Delete the jQuery wrapped object variable
    delete this.el




