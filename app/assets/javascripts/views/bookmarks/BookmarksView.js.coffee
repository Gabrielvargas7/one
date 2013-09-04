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
    'click #discover_menu_item':'renderDiscover'
    'click #my_bookmarks_menu_item':'renderMyBookmarks'
    'click img.trash_icon':'clickTrash'

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
    #@categoryCollection = new Mywebroom.Collections.
  fetchDiscoverBookmarks: ->
    console.log "hi"
    @discoverBookmarksCollection = new Mywebroom.Collections.IndexBookmarksWithBookmarksCategoryByItemIdCollection()
    @discoverBookmarksCollection.fetch
      async:false
      url: @discoverBookmarksCollection.url this.options.user_item_design.item_id
      success:(response)->
        console.log "discover Bookmarks fetch successful: "
        console.log response

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
    $('#my_bookmarks_menu_item').addClass 'bookmark_menu_selected'
    this
  renderDiscover:->
    $('#my_bookmarks_menu_item').removeClass 'bookmark_menu_selected'
    $('#discover_menu_item').addClass 'bookmark_menu_selected'
    $('.discover_submenu_section').removeClass('hidden')
    #@myBookmarksView.remove() if @myBookmarksView
    $(@myBookmarksView.el).hide()
    #Add sidebar (Make class display?)
    #Render Bookmarks api.
    #fetch DiscoverBookmarks
    @fetchDiscoverBookmarks()
    @bookmarksDiscoverView = new Mywebroom.Views.MyBookmarksView(collection:@discoverBookmarksCollection, template:JST['bookmarks/DiscoverBookmarksTemplate'])
    $(@el).append(@bookmarksDiscoverView.render().el)
    console.log('discover bookmarks!')
  renderMyBookmarks:->
    $('#my_bookmarks_menu_item').addClass 'bookmark_menu_selected'
    $('#discover_menu_item').removeClass 'bookmark_menu_selected'
    $('.discover_submenu_section').addClass('hidden')
    #@myBookmarksView.remove() if @myBookmarksView
    $(@myBookmarksView.el).hide()
    $(@bookmarksDiscoverView.el).hide()
    #@myBookmarksView = new Mywebroom.Views.MyBookmarksView(collection:@collection)
    $(@myBookmarksView.el).show()
    #$(@el).append(@myBookmarksView.render().el)
    this

  clickTrash: (event)->
    #hoveredEl = event.currentTarget
    #hoveredEl
    console.log "You want to delete an item"

  closeView:->
    this.remove()
