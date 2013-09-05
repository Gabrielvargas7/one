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
    'click .discover_bookmarks_bottom .bookmark_grid_item':'previewMode'

  }
  #*******************
  #**** Functions  Initialize Room
  #*******************

  initialize: ->
    #fetch bookmark data
    @collection = new Mywebroom.Collections.IndexUserBookmarksByUserIdAndItemIdCollection()
    @collection.fetch
      async:false
      url:@collection.url '23', this.options.user_item_design.item_id
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
    $('.discover_submenu').removeClass('bookmark_menu_selected')
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
    $('#discover_menu_item').removeClass 'bookmark_menu_selected'
    $('.discover_submenu').removeClass 'bookmark_menu_selected'
    $(event.currentTarget).addClass('bookmark_menu_selected')
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

  previewMode:(event)->
    #we'll have previewView to correspond to discover_bookmarks
    #and browseMode to correspond to my_bookmarks
    #open in iframe
    bookmarkClicked=@discoverCollection.get(event.currentTarget.dataset.cid)
    urlToOpen= bookmarkClicked.get('bookmark_url')
    previewModeView = new Mywebroom.Views.BookmarkPreviewModeView(model:bookmarkClicked)
    #Edit sidebar menu 
    #hide categories
    $(@el).append(previewModeView.render().el)#"<iframe src="+"'"+urlToOpen+"'>"+"</iframe>")
    previewModeView.on('closedView',@closePreviewMode())
    console.log("preview site!"+urlToOpen)
    console.log(bookmarkClicked)
  closePreviewMode:->
    console.log 'close previewmode.'

    #show sidebar categories.
  clickTrash: (event)->
    #hoveredEl = event.currentTarget
    #hoveredEl
    console.log "You want to delete an item"

  closeView:->
    this.remove()
