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
    'click .discover_submenu':'showCategory'

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
    @discoverCategoriesCollection = new Mywebroom.Collections.IndexBookmarksCategoriesByItemId()
    @discoverCategoriesCollection.fetch
      async:false
      url: @discoverCategoriesCollection.url this.options.user_item_design.item_id
      success:(response) ->
        console.log("categories fetch successful: ")
        console.log(response)
  fetchDiscoverBookmarks: ->


  #*******************
  #**** Render
  #*******************
  render: ->
    console.log("bookmark view: "+this.options.user_item_design)
    console.log(this.options.user_item_design)
    #alert("user_item_design: "+this.options.user_item_design.id+" user id: "+this.options.user.id)
    $(@el).append(@template(user_item_design:this.options.user_item_design, collection:@collection, categories:@discoverCategoriesCollection))
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
    @currentBookmarkbyCategoryView.remove() if @currentBookmarkbyCategoryView

    #Add sidebar (Make class display?)
    #Render Bookmarks api.
    #fetch DiscoverBookmarks here so we can reuse the view in other places
    @discoverCollection = new Mywebroom.Collections.IndexBookmarksWithBookmarksCategoryByItemIdCollection()
    @discoverCollection.fetch
      async:false
      url: @discoverCollection.url this.options.user_item_design.item_id
      success:(response)->
        console.log "discover Bookmarks fetch successful: "
        console.log response
    #@fetchDiscoverBookmarks()
    @bookmarksDiscoverView = new Mywebroom.Views.DiscoverBookmarksView(collection:@discoverCollection, user_item_design:this.options.user_item_design)
    $(@el).append(@bookmarksDiscoverView.render().el)

  renderMyBookmarks:->
    $('#my_bookmarks_menu_item').addClass 'bookmark_menu_selected'
    $('#discover_menu_item').removeClass 'bookmark_menu_selected'
    $('.discover_submenu_section').addClass('hidden')
    @currentBookmarkbyCategoryView.remove() if @currentBookmarkbyCategoryView
    #@myBookmarksView.remove() if @myBookmarksView
    $(@myBookmarksView.el).hide()
    $(@bookmarksDiscoverView.el).hide()
    #@myBookmarksView = new Mywebroom.Views.MyBookmarksView(collection:@collection)
    $(@myBookmarksView.el).show()
    #$(@el).append(@myBookmarksView.render().el)
    this
  showCategory:(event)->
    categoryId = event.currentTarget.dataset.id
    @currentBookmarkbyCategoryView.remove() if @currentBookmarkbyCategoryView 
    #get the category bookmarks
    @currentBookmarkbyCategoryCollection = new Mywebroom.Collections.IndexBookmarksByBookmarksCategoryId()
    @currentBookmarkbyCategoryCollection.fetch
      async:false
      url: @currentBookmarkbyCategoryCollection.url categoryId
      success:(response) ->
        console.log("BookmarkbyCategoryCollection fetch successful:")
        console.log(response)
    #display the category bookmarks
    @bookmarksDiscoverView.remove()
    @currentBookmarkbyCategoryView = new Mywebroom.Views.DiscoverBookmarksView(collection:@currentBookmarkbyCategoryCollection)
    $(@el).append(@currentBookmarkbyCategoryView.render().el)
  clickTrash: (event)->
    #hoveredEl = event.currentTarget
    #hoveredEl
    console.log "You want to delete an item"

  closeView:->
    this.remove()
