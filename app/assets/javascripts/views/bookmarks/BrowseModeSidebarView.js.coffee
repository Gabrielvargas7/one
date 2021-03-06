class Mywebroom.Views.BrowseModeSidebarView extends Backbone.View
  
  className:'browse_mode_sidebar_wrap'
  
  template:JST['bookmarks/BrowseModeSidebarTemplate']
  
  events:
    'click .browse_mode_sidebar_icons':'sideBarActiveSiteChange'
    'mouseenter .halfCircleRight':'showSideBar'


  initialize:->
    this.on('render',@setScroll)
    @spriteUrl = Mywebroom.State.get('staticContent').findWhere('name':'bookmark-main-icons').get('image_name').url
    @sideBarInView = true #sidebar is in view (vs. expand button is in view)
  
  render:->
    if @model
      #fetch data here
      @collection = new Mywebroom.Collections.IndexUserBookmarksByUserIdAndItemIdCollection()
      @collection.fetch
        url:@collection.url(Mywebroom.State.get('signInUser').get('id'),@model.get('item_id'))
        async:false
      #@collection = @itemBookmarksCollection.first(4)
      @model.on('change',@render,this)
      @tagActiveSites()
    $(@el).html(@template(collection:@collection,model:@model,spriteUrl:@spriteUrl))
    
    #Start event timers for menu timeouts
    @showSideBar()
    this

  ###
  Tag items in collection that are active so we can put the right class on them in render
  ###
  tagActiveSites:->
    #for each item collection, see if there's a data-id= to it in DOM
    #Check for active sites list first. If none, then model has blueBorder.
    #Otherwise, iterate through dom.
    @model.set('blueBorder', true,{silent:true})

    #Check for active sites list to see if there's others in the DOM.
    if $('.browse_mode_site').length>0
      @collection.each(((item)->
         if $('.browse_mode_view [data-id='+item.get('id')+']').length>0
          item.set('blueBorder', true)
      ))

  setModel:(model)->
    @model.set(model.toJSON())

  sideBarActiveSiteChange:(event)->
    #console.log 'sidebar active site change. '
    event.stopPropagation()
    modelId= event.currentTarget.dataset.id
    modelClicked = @collection.get(modelId)
    #trigger an event pass model up.
    this.trigger 'BrowseMode:sidebarIconClick', modelClicked
  #Create SimplyScroll event for mybookmarks sidebar
  #Hope it dies quickly when the view closes

  showSideBar:->
    @sideBarInView = true
    #1. Fade Out Expand Button

    $('.halfCircleRight').css 'opacity', 0
    #Fade in Bar
    $('.browse_mode_sidebar').css 'left',0

    #2. Start event to detect inactivity on sidebar

    #2.1 Start to timeout unless the mouse enters the sidebar. 
    that = this
    @hideTimer = setTimeout @hideSideBar,2000

    #2.2 Clear timer once mouse enters the sidebar. 
    @$('.browse_mode_sidebar').off('mouseenter').on('mouseenter',{that},(event)->
      event.data.that.clearTimer(event))

    #2.3 Set timer once mouse leaves sidebar
    @$('.browse_mode_sidebar').off('mouseleave').on('mouseleave',{that},(event)->
      event.data.that.setHideTimer(event))

    #2.4 Clear the timer when the mouse enters the expand circle. (This is to prevent duplicate events)
    @$('.halfCircleRight').off('mouseenter').on('mouseenter',{that},(event)->
      event.data.that.clearTimer(event))

    #2.5 Do similar things for the Active Sites Menu- browse_mode_active_sites_menu in case its shown

    $('.browse_mode_active_sites_menu').off('mouseenter').on('mouseenter',{that},(event)->
      event.data.that.clearTimer(event))
    $('.browse_mode_active_sites_menu').off('mouseleave').on('mouseleave',{that},(event)->
      event.data.that.setHideTimer(event))

    $('#xroom_header').off('mouseenter').on('mouseenter',{that},(event)->
      event.data.that.clearTimer(event))
    # $('#xroom_header').off('mouseover').one('mouseover',{that},(event)->
    #   event.data.that.clearTimer(event))
    $('#xroom_header').off('mouseleave').on('mouseleave', {that}, (event)->
      event.data.that.setHideTimer(event))
    #$('#xroom_header_active_sites').off('mouseover').on('mouseover',{that},(event)->
    #   console.log 'active sites btn mouseover one'
    #   clearTimeout hideTimer if hideTimer != null)
  hideSideBar:->
  #Context/scope is the window here. So, let's use state model to set theimportant bits
    Mywebroom.State.get('browseModeView').browseModeSidebarView.sideBarInView = false
    #1. Fade In Buttons
    @$('.halfCircleRight').css 'opacity', 1
    @$('.browse_mode_sidebar').css 'left',-90

    #2. Clear timer event
    @$('.browse_mode_sidebar').off('mouseleave')

    #3. If Active Sites Menu shown, need to hide it. 
    if Mywebroom.State.get('browseModeView').activeMenuView && !Mywebroom.State.get('browseModeView').activeMenuView.isHidden()
      Mywebroom.State.get('browseModeView').activeMenuView.hideActiveMenu()

    #Get rid of extra events from showSidebar
    $('#xroom_header').off('mouseenter mouseover mouseleave')
    $('.browse_mode_active_sites_menu').off('mouseenter mouseleave')


  setScroll:->
    #console.log 'one day i will scroll things beautifully.'
    #Determine if we need to scroll.
    #
    if @collection.length > 5
      $("#browse_mode_scroller").simplyScroll
        customClass: "vert"
        orientation: "vertical"
        auto: false
        manualMode: "loop"
        frameRate: 20
        speed: 5

  clearTimer:->
    clearTimeout(@hideTimer) if @hideTimer != null
  setHideTimer:->
    @hideTimer = setTimeout @hideSideBar,2000
