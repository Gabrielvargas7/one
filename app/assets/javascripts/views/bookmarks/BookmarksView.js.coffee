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
    'click .my_bookmarks_more_square_wrap':'renderDiscover'
  }
  #*******************
  #**** Functions  Initialize Room
  #*******************

  initialize: ->
    #fetch bookmark data
    @getMyBookmarksCollection() #Referred as @collection
    @getDiscoverCategoriesCollection() #referred as @discoverCategoriesCollection
    
    self= this
    Mywebroom.App.vent.on('BrowseMode:closeBookmarkView',@closeView,self)

  #*******************
  #**** Render
  #*******************
  render: ->
    #console.log("bookmark view: "+this.options.item_id)
    #alert("user_item_design: "+this.options.user_item_design.id+" user id: "+this.options.user)
    $(@el).append(@template(user_item_design:this.options.item_id,items_name:this.options.items_name, collection:@collection, categories:@discoverCategoriesCollection))
    @myBookmarksView = new Mywebroom.Views.MyBookmarksView(collection:@collection)
    $(@el).append(@myBookmarksView.render().el)
    #set .my_bookmarks_bottom to 100% width minus the sidebar width
    # $('.my_bookmarks_bottom').css 'width',$(window).width()-270
    $('#my_bookmarks_menu_item').addClass 'bookmark_menu_selected'
    
  renderDiscover:(event)->
    if event
      event.stopPropagation() 
      event.preventDefault()
    @previewModeView.closeView() if @previewModeView
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
      url: @discoverCollection.url this.options.item_id
      success:(response)->
        #console.log "discover Bookmarks fetch successful: "
        #console.log response
    #@fetchDiscoverBookmarks()
    @bookmarksDiscoverView = new Mywebroom.Views.DiscoverBookmarksView(collection:@discoverCollection, user_item_design:this.options.item_id)
    $(@el).append(@bookmarksDiscoverView.render().el)
    #set .discover_bookmarks_bottom to 100% width minus the sidebar width
    # $('.discover_bookmarks_bottom').css 'width',$(window).width()-270
    that = this
    #$('#add_your_own_form').submit({that},@addCustomBookmark)
    $('#add_your_own_form').off('submit').on('submit',{that},@addCustomBookmark)

  renderMyBookmarks:(event)->
    event.preventDefault() if event
    event.stopPropagation() if event
    @previewModeView.closeView() if @previewModeView
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
      url:@collection.url this.options.user, this.options.item_id
    #$(@el).append(@myBookmarksView.render().el)
    #set .my_bookmarks_bottom to 100% width minus the sidebar width
    $('.my_bookmarks_bottom').css 'width',$(window).width()-270
    $(@myBookmarksView.el).show()
    #$(@el).append(@myBookmarksView.render().el)
    
  showCategory:(event)->
    event.preventDefault()
    event.stopPropagation()
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
        #console.log("BookmarkbyCategoryCollection fetch successful:")
        #console.log(response)
    #display the category bookmarks
    @bookmarksDiscoverView.remove()
    @currentBookmarkbyCategoryView = new Mywebroom.Views.DiscoverBookmarksView(collection:@currentBookmarkbyCategoryCollection)
    $(@el).append(@currentBookmarkbyCategoryView.render().el)
    #set .discover_bookmarks_bottom to 100% width minus the sidebar width
    # $('.discover_bookmarks_bottom').css 'width',$(window).width()-270

#PreviewMode: we'll have previewView to correspond to discover_bookmarks
#and browseMode to correspond to my_bookmarks
  previewMode:(event)->
    event.preventDefault()
    event.stopPropagation()
    #open in iframe
    bookmarkClicked= @discoverCollection.get(event.currentTarget.dataset.id)
    urlToOpen= bookmarkClicked.get('bookmark_url')
    
    #Create Sidebar Interface
    if bookmarkClicked.get('i_frame') is 'y'
      @previewModeView = new Mywebroom.Views.BookmarkPreviewModeView(model:bookmarkClicked)
      $(@el).append(@previewModeView.render().el)
      @previewModeView.once('closedView',@closePreviewMode,this)

      #Add Site to My Bookmarks from Preview Mode
      @previewModeView.on('PreviewMode:saveSite',((bookmarkClick)->
        
        #Need to fetch MyBookmarks to get an accurate last position
        #If I've added 2 bookmarks from discover, then preview, then save site, 
        #    the position count is not accurate and save doesn't work.
        @collection.fetch
          async:false
          url:@collection.url this.options.user, this.options.item_id
          success:(response) ->
            #console.log("bookmark fetch successful: ")
            #console.log(response)

        postBookmarkModel = new Mywebroom.Models.CreateUserBookmarkByUserIdBookmarkIdItemId({itemId:bookmarkClick.get('item_id'), bookmarkId:bookmarkClick.get('id'),userId:Mywebroom.State.get('signInUser').get('id')})
        lastBookmarkPosition = parseInt(_.last(@collection.models).get('position'))
        postBookmarkModel.set 'position',lastBookmarkPosition+1   
        postBookmarkModel.save {},
          success: (model, response)->
            #console.log('postBookmarkModel SUCCESS:')
            #console.log(response)
          error: (model, response)->
            console.error('postBookmarkModel FAIL:')
            console.error(response)

      ),this)
      #console.log(bookmarkClicked)
    else
      window.open urlToOpen,"_blank" 
  closePreviewMode:->
    #console.log 'close previewmode.'


    #show sidebar categories.
  clickTrash: (event)->
    #hoveredEl = event.currentTarget
    #hoveredEl
    #console.log "You want to delete an item"

  #*******************
  #**** addCustomBookmark
  #****** event data must contain that (context) 
  #*******************
  addCustomBookmark:(event)->
    event.preventDefault()
    event.stopPropagation()
    
    #Case, user clicked search, but not save. Then clicked search again.
    if $('.custom_bookmark_confirm_add_wrap img').length > 0
      $('.custom_bookmark_confirm_add_wrap img').remove()

    $('#add_your_own_box .err_response').addClass('hidden') if !$('#add_your_own_box .err_response').hasClass('hidden')

    #validate the url string
    customURL= $.trim $("input[name=url_input]").val()
    title = $.trim $("input[name=bookmark_title]").val()
    #The regex code is copied from the old Rooms code. 
    customURL = "http://" + customURL  unless customURL.match(/^https?:\/\//) or customURL.match(/^spdy:\/\//)
    #http://stackoverflow.com/questions/833469/regular-expression-for-url
    url_match = customURL.match(/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/)
    title_match = title.length > 0 and title.length < 25
    
    #set up custom Bookmark properties and get snapshot
    if url_match and title_match
      #Add custom URL
      snapshot = "http://img.bitpixels.com/getthumbnail?code=67736&size=200&url=" + customURL
      customBookmark = new Mywebroom.Models.CreateCustomUserBookmarkByUserId()
      customBookmark.set
        'userId':Mywebroom.State.get('signInUser').get('id')
        'bookmark_url':customURL
        'title':title
        'image_name':snapshot
        'item_id': event.data.that.options.item_id
        'bookmarks_category_id':event.data.that.discoverCategoriesCollection.first().get('id')

      #Display picture now. Show confirm save.
      $('.custom_bookmark_confirm_add_wrap').prepend('<img src="'+customBookmark.get('image_name')+'">')
      $('.custom_bookmark_confirm_add_wrap').show()
      $('.save_site_button').show()
      
      #clear any save site events and add one listener to save the custom bookmark model.
      #pass to event: customBookmark and context-that 
      that = event.data.that
      $('.save_site_button').off('click').one('click',{customBookmark,that},((event)->
        
        event.stopPropagation()
        
        #Fetch MyBookmarks to get an accurate last position parameter
        # -Example: If I've added 2 bookmarks from discover, then preview, then save site, the position count is not accurate and save doesn't work.
        event.data.that.collection.fetch
          async:false
          url:event.data.that.collection.url event.data.that.options.user, event.data.that.options.item_id
          success:(response) ->
            #console.log("bookmark fetch successful: ")
            #console.log(response)

        #set the position at the last possible moment so we don't fail.
        event.data.customBookmark.set
          'position':parseInt(event.data.that.collection.last().get('position'))+1

        #save the bookmark!
        event.data.customBookmark.save {},
        success: (model, response)->
          #console.log('post CUSTOM BookmarkModel SUCCESS:')
          #console.log(response)
          #Style- tell user it saved
          $('.save_site_button').hide()
          $('.custom_url_saved').show()

        error: (model, response)->
          console.error('post CUSTOM BookmarkModel FAIL:')
          console.error(response)
          #Style- Error
          $('#add_your_own_box .err_response').removeClass('hidden')
          $('#add_your_own_box .err_response p').append('Oops! There was an error. Please try refreshing the page and try again.')
          $('.save_site_button').hide()

        
        #After 5 seconds, clear form and remove image
        setTimeout((->
          $('#add_your_own_form')[0].reset()
          #turn this event back on in case user submits another form
          $('#add_your_own_form').off('submit').on('submit',{that},event.data.that.addCustomBookmark)
          $('.custom_url_saved').hide()
          $('.custom_bookmark_confirm_add_wrap img').remove()),3000)
        ))
      
    else
      #Show an error to the user.
      $('#add_your_own_box .err_response').removeClass('hidden')
      $('#add_your_own_box .err_response p').append('Oops! There was an error in your url or the title was too long.')
      #console.log "There was an error in your url or the title was too long."

  
  getMyBookmarksCollection:->
    @collection = new Mywebroom.Collections.IndexUserBookmarksByUserIdAndItemIdCollection()
    @collection.fetch
      async:false
      url:@collection.url this.options.user, this.options.item_id
      success:(response) ->
        #console.log("bookmark fetch successful: ")
        #console.log(response)

  getDiscoverCategoriesCollection:->
    @discoverCategoriesCollection = new Mywebroom.Collections.IndexBookmarksCategoriesByItemId()
    @discoverCategoriesCollection.fetch
      async:false
      url: @discoverCategoriesCollection.url this.options.item_id
      success:(response) ->
        #console.log("categories fetch successful: ")
        #console.log(response)
  
  ###
  # Highlight a bookmark item by and make sure the user sees it. (From "Try in My Room")
  ###
  highlightItem:(id)->
    #1. Highlight item
    $('.bookmark_grid_item[data-id="'+id+'"]').addClass('blue_highlight')
    
    #2. Make sure its in the view-port. 
    container = $('.discover_bookmarks_bottom')
    if container.length is 0
      container = $('.my_bookmarks_bottom')
    if container.length is 1
      scrollTo = $('.bookmark_grid_item[data-id="'+id+'"]')[0]
      scrollTo.scrollIntoView(true)
      #container.scrollTop(scrollTo.offset().top - container.offset().top + container.scrollTop())

  closeView:->
    this.remove()
