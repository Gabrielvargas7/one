class Mywebroom.Views.BrowseModeView extends Backbone.View

  #Browse Mode always has one modelToBrowse which represents the active iframe website showing
  @modelToBrowse
  
  className:"browse_mode_view"
  
  template:JST['bookmarks/BrowseModeTemplate']
  
  events:
    'click #browse_mode_site_nav_close':'closeView'
    'click #browse_mode_site_nav_minimize':'minimizeSite'
    'click #browse_mode_site_nav_refresh':'refreshSite'
    'click #browse_mode_active':'showActiveMenu'
    'click .active_menu_site_icon':'iconActiveSiteChange'
    'click #browse_mode_discover':'showBookmarksView'
    'click #browse_mode_bookmarks':'showBookmarksView'
    
  ###
  Get the current site in view from the DOM. (Note, this can exist if BrowseModeView is hidden)
  ###
  $currentActiveSiteHTML:->
    $('.current_browse_mode_site')


  ###
  Get the list of active sites from the DOM. These all have iframes representing the different sites.
  ###
  $activeSites:->
    $('.browse_mode_site')

  ###
  initialize an ActiveMenuView (the top bar with active sites list) and the activeSitesCollection.
  ###

  initialize:->
    @activeSitesCollection=new Backbone.Collection()
    @activeMenuView = new Mywebroom.Views.BrowseActiveMenuView(collection:@getActiveSitesCollection())
    $(@el).append(@activeMenuView.render().el)
    @activeMenuView.hideActiveMenu()

  ###
  Getters and Setters

  1a. 1b. get set ModelToBrowse
  2a. 2b. remove set CurrentActiveSite 
  3.      get ActiveSitesCollection 
  ###
  
  #1a.get ModelToBrowse
  getModelToBrowse:->
    @modelToBrowse

  #1b. set ModelToBrowse
  setModelToBrowse:(model)->
    @modelToBrowse=model

  #2a. remove CurrentActiveSite
  removeCurrentActiveSite:(target)->
    #remove current active site
    $(target).removeClass 'current_browse_mode_site'

  #2ba. set CurrentActiveSite
  setCurrentActiveSite:(target)->
    $(target).addClass 'current_browse_mode_site'

  #3. get ActiveSitesCollection 
  getActiveSitesCollection:->
    @activeSitesCollection
  

  ###
  return the item_name of the ModelToBrowse (current bookmark to browse)
  ###
  getItemNameOfMyBookmark:->
    #Compare modelToBrowse ID to state room designs items id
    if @getModelToBrowse() is undefined
      return "Item"
      #TODO throw error. 
    Mywebroom.Helpers.getItemNameOfItemId(parseInt(@getModelToBrowse().get('item_id')))

  
  ###
  render- The nature of this view is that this render is called once. 
        - Note that we frequently rerender the browseModeSidebarView.
        - Create BrowseModeSidebarView but don't render until the user clicks a site. (BrowseMode is created on room load without a model)
  ### 
  render:->
    @browseModeSidebarView.remove() if @browseModeSidebarView
    @browseModeSidebarView = new Mywebroom.Views.BrowseModeSidebarView(model:@modelToBrowse)
    #$(@el).html(@browseModeSidebarView.render().el)
    $(@el).append(@template(model:@getModelToBrowse()))
    this


  ###
  show the active sites menu or close it if its already open. 
  ###
  showActiveMenu:-> 
    if !@activeMenuView
      console.log "BrowseMode showActiveMenu"
      #Create new active menu view
      @activeMenuView = new Mywebroom.Views.BrowseActiveMenuView(collection:@getActiveSitesCollection())
      $(@el).append(@activeMenuView.render().el)
      @activeMenuView.showActiveMenu()
    else
      @activeMenuView.showActiveMenu()


  ###
  show Bookmarks View or the Discover View 
  ###
  showBookmarksView:(event)->
    #get model item-id to show that item's bookmarks view and append it
    itemId = @modelToBrowse.get('item_id')
    userId = Mywebroom.State.get('signInUser').get('id')
    
    bookmarksView = new Mywebroom.Views.BookmarksView({item_id:itemId,user:userId,items_name:@getItemNameOfMyBookmark()})
    
    #Append the view to DOM and show it. 

    $('#room_bookmark_item_id_container_'+itemId).append(bookmarksView.el)
    $('#room_bookmark_item_id_container_'+itemId).show()
    $('#xroom_bookmarks').show()

    bookmarksView.render()

    #Render Discover View if needed
    if event.currentTarget is $('#browse_mode_discover')[0]
      bookmarksView.renderDiscover()

    #hide BrowseModeView  
    @activeMenuView.hideActiveMenu() if @activeMenuView #hide activeMenuview
    $(@el).hide()                                       #hide BrowseModeView
    $('#browse_mode_item_name').remove()                 #hide "Your Object" hook

  ###
  activeSiteChange is called: - each time a user clicks a bookmark from MyBookmarks.
                              - when the user clicks a BrowseMode Sidebar icon.  
    It adds the new site to the collection and generates a new iframe
  ###
  activeSiteChange:(model)->
    # Check if the site is already in activeSitesCollection.
    if @getActiveSitesCollection().get(model)
      console.log "already here!"

      #1 Set ModelToBrowse from the model in the Active Sites Collection.
      @setModelToBrowse @getActiveSitesCollection().get(model)

      #2. re-render the browseModeSidebarView
      @browseModeSidebarView.remove() if @browseModeSidebarView
      @browseModeSidebarView = new Mywebroom.Views.BrowseModeSidebarView(model:@modelToBrowse)
      @browseModeSidebarView.on('BrowseMode:sidebarIconClick',@activeSiteChange,this)
      $(@el).append(@browseModeSidebarView.render().el)

      #3. Adjust DOM
        #  i.   Remove current Active Site class
        #  ii.  Set the currentActive Site on corresponding DOM view for modelToBrowse.
        #  iii. Add Object hook to DOM. (Item Name of Bookmark)

      @removeCurrentActiveSite(@$currentActiveSiteHTML())
            
      @setCurrentActiveSite $('.browse_mode_site[data-id='+model.get('id')+']')
      if $('#browse_mode_item_name').length is 0
        #$('#rooms_header_main_menu').prepend('<li id="browse_mode_item_name">Your '+@getItemNameOfMyBookmark()+'</li>') 
        $('#browse_mode_item_name_wrap').prepend('<div id="browse_mode_item_name">Your '+@getItemNameOfMyBookmark()+'</div>')
    else
    #Add to active sites collection

      #1 Set ModelToBrowse
      @setModelToBrowse model
    
      #2 Add to active sites collection.
      @getActiveSitesCollection().add(model)
    
      #3 Remove current active site
      @removeCurrentActiveSite(@$currentActiveSiteHTML())
      
      #4 Generate the proper newIframeHTML. (Template has current active site tag.)
      if model.get('i_frame') is 'n'
        #open in target
        window.open model.get('bookmark_url'),"_blank"
        newIframeHTML = JST['bookmarks/BrowseModeNoIframeTemplate'](model:@getModelToBrowse())
      else   
        newIframeHTML = JST['bookmarks/BrowseModeIframeTemplate'](model:@getModelToBrowse())
      
      #5 Append newIframeHTML to DOM
      $('.browse_mode_site_wrap').append(newIframeHTML)
      
      #6 Rerender the sidebar menu 
      # 6i. Remove Sidebar View if there is one.
      @browseModeSidebarView.remove() if @browseModeSidebarView

      # 6ii. Create New Sidebar View
      @browseModeSidebarView = new Mywebroom.Views.BrowseModeSidebarView(model:@modelToBrowse)

      # 6iii. Create On Event for clicking the sidebar icons. 
      @browseModeSidebarView.on('BrowseMode:sidebarIconClick',@activeSiteChange,this)

      # 6iv. Append sidebar view to el
      $(@el).append(@browseModeSidebarView.render().el)
      
      # 6v. set the Sidebar Icon scrolling if needed. 
      @browseModeSidebarView.setScroll()

      # 6vi. Set hover events for sidebar. 
      @setSidebarHover();
      
      #7 Set Header Item Name
      #$('#rooms_header_main_menu').prepend('<li id="browse_mode_item_name">Your '+@getItemNameOfMyBookmark()+'</li>') if $('#browse_mode_item_name').length is 0
      $('#browse_mode_item_name_wrap').prepend('<div id="browse_mode_item_name">Your '+@getItemNameOfMyBookmark()+'</div>') if $('#browse_mode_item_name').length is 0
  
      
  ###
  iconActiveSiteChange is called:  when user clicks icon in the Active Sites Menu
     changes the current active site in view. 
  ###
  iconActiveSiteChange:(event)->
    #NOTE: The model clicked is already part of activeSitesCollection

    #1. Get model from activeSitesCollection
    #1a. Pass to activeSiteChange
    
    siteId= event.currentTarget.dataset.id
    @setModelToBrowse @getActiveSitesCollection().get(siteId)
   
    #2. Rerender the sidebar menu 
    #2i. Remove Sidebar View if there is one.
    @browseModeSidebarView.remove() if @browseModeSidebarView

    #2ii. Create New Sidebar View
    @browseModeSidebarView = new Mywebroom.Views.BrowseModeSidebarView(model:@modelToBrowse)
    
    #2iii. Create On Event for clicking the sidebar icons. 
    @browseModeSidebarView.on('BrowseMode:sidebarIconClick',@activeSiteChange,this)
    
    #2iv. Append sidebar view to el
    $(@el).append(@browseModeSidebarView.render().el)
    
    #2v. set the Sidebar Icon scrolling if needed.
    @browseModeSidebarView.setScroll()

    #2vi. Set hover events for sidebar. 
    @setSidebarHover();

    #3. Set Header Item Name
    $('#browse_mode_item_name').remove()
    #$('#rooms_header_main_menu').prepend('<li id="browse_mode_item_name">Your '+@getItemNameOfMyBookmark()+'</li>') if $('#browse_mode_item_name').length is 0
    $('#browse_mode_item_name_wrap').prepend('<div id="browse_mode_item_name">Your '+@getItemNameOfMyBookmark()+'</div>') if $('#browse_mode_item_name').length is 0

    #4. Remove Current Active Site
    @removeCurrentActiveSite(@$currentActiveSiteHTML())
    
    #5. set current active site to this model in iframe. 
    @setCurrentActiveSite $('.browse_mode_site[data-id='+siteId+']') 
  
  ###
  Browse Mode Iframe Nav (3 buttons)

  1. Refresh Site 
  2. Minimize Site
  3. Close View is unique because it also hides the Browse Mode View 
  ###

  ###
  1. Called when the user clicks Refresh in the Browse Mode Nav.
  ###
  refreshSite:(event)->
    console.log "refresh site!"
    originalURL = $('.current_browse_mode_site').attr 'src'
    $('.current_browse_mode_site').attr 'src',originalURL
  
  ###
  2. Called when user clicks Minimize in the Browse Mode Nav.
  ###
  minimizeSite:(event)->
    console.log("minimize view")
    #Add to active sites by removing class 'current_active_site'
    @removeCurrentActiveSite(event.currentTarget)
    #Hide Active Sites View if it exists. 
    @activeMenuView.hideActiveMenu() if @activeMenuView
    #hide the view and go back to room.
    $(@el).hide()
    $('#browse_mode_item_name').remove()

  ###
  3. Called when user clicks Close in the Browse Mode Nav.
    - Removes the site from Active Sites Collection and hides this view. 
    - Note that this view is hidden. It is never removed/destroyed.
  ###
  closeView:->
    #1. Remove current active site from the active sites list.
    $(@$currentActiveSiteHTML()).remove()

    #2. Remove the model from activeSitesCollection
    @getActiveSitesCollection().remove(@getModelToBrowse())
    
    #3. Hide Active Sites View if it exists. 
    @activeMenuView.hideActiveMenu() if @activeMenuView
    
    #4. Hide Browse Mode View
    $(@el).hide() 

    #5. Remove Object Header Name
    $('#browse_mode_item_name').remove()

  setSidebarHover:->
    $('#browse_mode_active_default').off('mouseover').mouseover(->
      $('#browse_mode_active_highlight').show()
      $('#browse_mode_active_default').hide()
      )
    $('#browse_mode_active_highlight').off('mouseout').mouseout(->
        $('#browse_mode_active_highlight').hide()
        $('#browse_mode_active_default').show()
      )
    $('#browse_mode_discover_default').off('mouseover').mouseover(->
      $('#browse_mode_discover_highlight').show()
      $('#browse_mode_discover_default').hide()
      )
    $('#browse_mode_discover_highlight').off('mouseout').mouseout(->
        $('#browse_mode_discover_highlight').hide()
        $('#browse_mode_discover_default').show()
      )
    $('#browse_mode_mybookmarks_default').off('mouseover').mouseover(->
      $('#browse_mode_mybookmarks_highlight').show()
      $('#browse_mode_mybookmarks_default').hide()
      )
    $('#browse_mode_mybookmarks_highlight').off('mouseout').mouseout(->
        $('#browse_mode_mybookmarks_highlight').hide()
        $('#browse_mode_mybookmarks_default').show()
      )
