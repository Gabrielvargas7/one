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
      url:@collection.url this.options.user, this.options.user_item_design
      success:(response) ->
        console.log("bookmark fetch successful: ")
        console.log(response)
    #@categoryCollection = new Mywebroom.Collections.
    @discoverCategoriesCollection = new Mywebroom.Collections.IndexBookmarksCategoriesByItemId()
    @discoverCategoriesCollection.fetch
      async:false
      url: @discoverCategoriesCollection.url this.options.user_item_design
      success:(response) ->
        console.log("categories fetch successful: ")
        console.log(response)
    self= this
    Mywebroom.App.vent.on('BrowseMode:closeBookmarkView',@closeView,self)
  #*******************
  #**** Render
  #*******************
  render: ->
    console.log("bookmark view: "+this.options.user_item_design)
    #alert("user_item_design: "+this.options.user_item_design.id+" user id: "+this.options.user)
    $(@el).append(@template(user_item_design:this.options.user_item_design, collection:@collection, categories:@discoverCategoriesCollection))
    @myBookmarksView = new Mywebroom.Views.MyBookmarksView(collection:@collection)
    $(@el).append(@myBookmarksView.render().el)
    #set .my_bookmarks_bottom to 100% width minus the sidebar width
    $('.my_bookmarks_bottom').css 'width',$(window).width()-270
    $('#my_bookmarks_menu_item').addClass 'bookmark_menu_selected'
    
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
      url: @discoverCollection.url this.options.user_item_design
      success:(response)->
        console.log "discover Bookmarks fetch successful: "
        console.log response
    #@fetchDiscoverBookmarks()
    @bookmarksDiscoverView = new Mywebroom.Views.DiscoverBookmarksView(collection:@discoverCollection, user_item_design:this.options.user_item_design)
    $(@el).append(@bookmarksDiscoverView.render().el)
    #set .discover_bookmarks_bottom to 100% width minus the sidebar width
    $('.discover_bookmarks_bottom').css 'width',$(window).width()-270
    that = this
    $('#add_your_own_form').submit({that},@addCustomBookmark)
  renderMyBookmarks:->
    $('#my_bookmarks_menu_item').addClass 'bookmark_menu_selected'
    $('#discover_menu_item').removeClass 'bookmark_menu_selected'
    $('.discover_submenu_section').addClass('hidden')
    @currentBookmarkbyCategoryView.remove() if @currentBookmarkbyCategoryView
    #@myBookmarksView.remove() if @myBookmarksView
    #@myBookmarksView.remove()
    $(@bookmarksDiscoverView.el).hide() if @bookmarksDiscoverView
    #@myBookmarksView = new Mywebroom.Views.MyBookmarksView(collection:@collection)
    @collection.fetch
      reset:true
      async:false
      url:@collection.url this.options.user, this.options.user_item_design
    #$(@el).append(@myBookmarksView.render().el)
    #set .my_bookmarks_bottom to 100% width minus the sidebar width
    $('.my_bookmarks_bottom').css 'width',$(window).width()-270
    $(@myBookmarksView.el).show()
    #$(@el).append(@myBookmarksView.render().el)
    
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
    #set .discover_bookmarks_bottom to 100% width minus the sidebar width
    $('.discover_bookmarks_bottom').css 'width',$(window).width()-270

#PreviewMode: we'll have previewView to correspond to discover_bookmarks
#and browseMode to correspond to my_bookmarks
  previewMode:(event)->
    #open in iframe
    bookmarkClicked= @discoverCollection.get(event.currentTarget.dataset.id)
    urlToOpen= bookmarkClicked.get('bookmark_url')
    
    #Create Sidebar Interface
    if bookmarkClicked.get('i_frame') is 'y'
      previewModeView = new Mywebroom.Views.BookmarkPreviewModeView(model:bookmarkClicked)
      $(@el).append(previewModeView.render().el)
      previewModeView.once('closedView',@closePreviewMode,this)

      #Add Site to My Bookmarks from Preview Mode
      previewModeView.on('PreviewMode:saveSite',((bookmarkClick)->
        
        postBookmarkModel = new Mywebroom.Models.CreateUserBookmarkByUserIdBookmarkIdItemId({itemId:bookmarkClick.get('item_id'), bookmarkId:bookmarkClick.get('id'),userId:Mywebroom.State.get('signInUser').get('id')})
        lastBookmarkPosition = parseInt(_.last(@collection.models).get('position'))
        postBookmarkModel.set 'position',lastBookmarkPosition+1   
        postBookmarkModel.save {},
          success: (model, response)->
            console.log('postBookmarkModel SUCCESS:')
            console.log(response)
          error: (model, response)->
                console.log('postBookmarkModel FAIL:')
                console.log(response)

      ),this)
      console.log(bookmarkClicked)
    else
      window.open urlToOpen,"_blank" 
  closePreviewMode:->
    console.log 'close previewmode.'


    #show sidebar categories.
  clickTrash: (event)->
    #hoveredEl = event.currentTarget
    #hoveredEl
    console.log "You want to delete an item"

  addCustomBookmark:(event)->
    event.preventDefault()
    console.log "I'd like to add a custom bookmark"
    customURL= $.trim $("input[name=url_input]").val()
    title = $.trim $("input[name=bookmark_title]").val()
    #The regex code is copied from the old Rooms code. 
    customURL = "http://" + customURL  unless customURL.match(/^https?:\/\//) or customURL.match(/^spdy:\/\//)
    #http://stackoverflow.com/questions/833469/regular-expression-for-url
    url_match = customURL.match(/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/)
    title_match = title.length > 0 and title.length < 25
    if url_match and title_match
      #Add custom URL
      src = "http://img.bitpixels.com/getthumbnail?code=67736&size=200&url=" + customURL
      customBookmark = new Mywebroom.Models.CreateCustomUserBookmarkByUserId()
      customBookmark.set
        'userId':Mywebroom.State.get('signInUser').get('id')
        'bookmark_url':customURL
        'title':title
        'image_name':src
        'item_id': event.data.that.options.user_item_design
        'position':parseInt(event.data.that.collection.last().get('position'))+1
        'bookmarks_category_id':event.data.that.discoverCategoriesCollection.first().get('id')
      console.log customBookmark
      #We want to just display picture now. If click Save Site is clicked, then save the model
      $('.custom_bookmark_confirm_add_wrap').prepend('<img src="'+customBookmark.get('image_name')+'">')
      $('.custom_bookmark_confirm_add_wrap').show()
      $('.save_site_button').on('click',{customBookmark},((event)->
        event.stopPropagation()
        event.data.customBookmark.save {},
        success: (model, response)->
          console.log('post CUSTOM BookmarkModel SUCCESS:')
          console.log(response)
        error: (model, response)->
              console.log('post CUSTOM BookmarkModel FAIL:')
              console.log(response)
        #After 5 seconds, clear form and remove image?
        ))
      
    else
      #Show an error to the user. 
      console.log "There was an error in your url or the title was too long."
  closeView:->
    this.remove()
