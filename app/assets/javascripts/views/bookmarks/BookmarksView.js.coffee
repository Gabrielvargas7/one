class Mywebroom.Views.BookmarksView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Templeate
  #*******************


  #*******************
  #**** Events
  #*******************

  events:{

  }
#  **********************
#  *** function showProfile
#  **********************

  initialize: ->

  #*******************
  #**** Render
  #*******************
  render: ->
    console.log("bookmark view: "+this.options.user_item_design)
    console.log(this.options.user_item_design)
    alert("user_item_design: "+this.options.user_item_design.id+" user id: "+this.options.user.id)
    $(@el).append()
    this

  #*******************
  #**** Functions  Initialize Room
  #*******************

