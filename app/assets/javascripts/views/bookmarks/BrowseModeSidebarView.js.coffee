class Mywebroom.Views.BrowseModeSidebarView extends Backbone.View
  className:'browse_mode_sidebar'
  template:JST['bookmarks/BrowseModeSidebarTemplate']
  events:
    'click .browse_mode_sidebar_icons':'sideBarActiveSiteChange'
  initialize:->
    this.on('render',@setScroll)
    
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
    $(@el).html(@template(collection:@collection,model:@model))
    #@setScroll()
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
    console.log 'sidebar active site change. '
    debugger;
    event.stopPropagation()
    modelId= event.currentTarget.dataset.id
    modelClicked = @collection.get(modelId)
    #trigger an event pass model up.
    this.trigger 'BrowseMode:sidebarIconClick', modelClicked
  #Create SimplyScroll event for mybookmarks sidebar
  #Hope it dies quickly when the view closes
  
  setScroll:->
    console.log 'one day i will scroll things beautifully.'
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

