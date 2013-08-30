class Mywebroom.Views.BookmarksView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************
  className:'bookmark_view'

  #*******************
  #**** Templeate
  #*******************
  template:JST['bookmarks/BookmarksMenuTemplate']

  #*******************
  #**** Events
  #*******************

  events:{
    'click .bookmark_view':'closeView'
    'click .bookmarks_close_button':'closeView'

  }
  #*******************
  #**** Functions  Initialize Room
  #*******************

  initialize: ->
    #fetch bookmark data
    @collection = new Mywebroom.Collections.IndexBookmarksWithBookmarksCategoryByItemIdCollection()
    @collection.fetch
      async:false
      url:@collection.url this.options.user_item_design.item_id
      success:(response) ->
        console.log("bookmark fetch successful: ")
        console.log(response)


  #*******************
  #**** Render
  #*******************
  render: ->
    console.log("bookmark view: "+this.options.user_item_design)
    console.log(this.options.user_item_design)
    #alert("user_item_design: "+this.options.user_item_design.id+" user id: "+this.options.user.id)
    $(@el).append(@template(user_item_design:this.options.user_item_design, collection:@collection))
    @myBookmarksView = new Mywebroom.Views.MyBookmarksView(collection:@collection)
    $(@el).append(@myBookmarksView.render().el)
    this



  closeView:->
    this.remove()
