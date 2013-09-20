class Mywebroom.Views.BookmarkHomeView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************


  #*******************
  #**** Templeate
  #*******************

  template: JST['bookmarks/BookmarkHomeTemplate']


  #*******************
  #**** Events
  #*******************

  events:{

  }

  #*******************
  #**** Initialize
  #*******************
  initialize: ->


    #*******************
    #**** Render
    #*******************
  render: ->
    $(@el).append(@template(user_item_design:this.options.user_item_design))
    this

