class Mywebroom.Views.ActivityItemLargeView extends Backbone.View
  template: JST['profile/ProfileActivityItemLargeTemplate']
  className: 'activity_item_large_wrap'
  initialize: ->
     _.bindAll this, 'insideHandler', 'outsideHandler'
     @originalCollection=this.options.originalCollection
     $('body').on('click', this.outsideHandler);
     #$('div').not('.activity_item_large_wrap *').on('click', this.outsideHandler);
     if @model.collection.constructor.name is Mywebroom.Collections.IndexUsersPhotosByUserIdByLimitByOffsetCollection.name
        @template = JST['profile/ProfilePhotosLargeTemplate']
      @fbUrl = @generateFacebookURL()
  events:
    'click #large_item_prev':'showNext'
    'click #large_item_next':'showNext'
    'click .profile_large_item_try_it_button':'showStore'
    'click .gridItem':'closeView'
    'click .pinterest_item':'pinIt'
  
  render: ->
    $("#profile_drawer").css "width", "1320px" 
    #user_profile is sent to template for the case that we are in Photos view
    $(@el).html(@template(model:@model,fbUrl:@fbUrl,user_profile:Mywebroom.State.get('roomData').get('user_profile')))
    FB.XFBML.parse($(@el)[0])
    #The social View is in the template because
    #the styling was not right with this view. 
    this
  
  insideHandler: (event) ->
    event.stopPropagation()
    console.log "insideHandler called"
  
  outsideHandler: (event) ->
    console.log "outsideHandler called"
    console.log(event)
    #If event src element is try in my room, close this view and open store.
    #if event src is next or prev, change model to next in collection.
    #else close view
    @closeView()
    return false
  
  closeView: ->
    $('body').off('click', this.outsideHandler);
    #change profile_drawer widths back to original
    $("#profile_drawer").css "width", "760px"
    this.$el.remove()
    console.log "ActivityItemLargeView closed"
    this
  
  showNext:(event) ->
    event.stopPropagation()
    this.trigger('ProfileActivityLargeView:showNext',event,@model)
  
  showStore:(event)->
    event.stopPropagation()
    #If room is not self, go to my room with params. 
    if Mywebroom.State.get('roomState') != "SELF"
      if @model.get('bookmark_url')
        paramType = "bookmark"
        paramId = @model.get('id')
        #send item name, send item id
        paramItemId = @model.get('item_id')
        parameters = $.param({'type':paramType,'id':paramId,'item_id':paramItemId})
      else
        #its an object
        paramType= "items_design"
        paramId = @model.get('id')
      #send to my room
      parameters = parameters || $.param({'type':paramType,'id':paramId})
      #TODO If no one signed in, sent to landing page. 

      window.location.href= 'http://localhost:3000/room/'+ Mywebroom.State.get('signInUser').get('username')+'?'+parameters
    else
      
      #if item is object, show store. 
      #if item is bookmark add bookmark.
      if @model.get('bookmark_url')
        console.log 'this is a bookmark. add it to your collection!'
        console.log @model
        #get userID, Item ID, BookmarkID
        helper = new Mywebroom.Helpers.ItemHelper()
        userId= helper.getUserId()
        #Post bookmark
        position = @getMyBookmarksLength(userId)
        #CHeck if bookmark is here already:
        if !@myBookmarksCollection.get(@model.id)
          postBookmarkModel = new Mywebroom.Models.CreateUserBookmarkByUserIdBookmarkIdItemId({itemId:@model.get('item_id'), bookmarkId:@model.get('id'),userId:userId})
          postBookmarkModel.set 'position',position+1
          postBookmarkModel.save {},
            success: (model, response)->
              console.log('postBookmarkModel SUCCESS:')
              console.log(response)
            error: (model, response)->
                  console.log('postBookmarkModel FAIL:')
                  console.log(response)
        #Added confirmation.
        @$('.activity_item_large_view_img_wrap').append("<div class='large_item_just_added'>
        <p>Added!</p>
        <img src='http://res.cloudinary.com/hpdnx5ayv/image/upload/v1378226370/bookmarks-corner-icon-check-confirmation.png'>
        </div>")
      else
        console.log 'hide ya profile cause the store\'s comin out y\'all'
        console.log @model
        
        $('#xroom_profile').hide()
        @closeView()
        
        
        # (1) Show Store
        Mywebroom.Helpers.showStore()


        # (2) Switch to the hidden tab
        $('#storeTabs a[href="#tab_hidden"]').tab('show')
    
    
        # (3) Use model to populate view
        Mywebroom.State.get("storeMenuView").appendOne(@model)
        
        
    
  getMyBookmarksLength:(userId)->
    @myBookmarksCollection = new Mywebroom.Collections.IndexUserBookmarksByUserIdAndItemIdCollection()
    @myBookmarksCollection.fetch
      async:false
      url:@myBookmarksCollection.url userId, @model.get('item_id')
    parseInt(_.last(@myBookmarksCollection.models).get('position'))
  
  pinIt:(event)->
    event.preventDefault()
    event.stopPropagation()
    pinterestURL= @generatePinterestUrl()
    if pinterestURL
      window.open(pinterestURL,'_blank','width=750,height=350,toolbar=0,location=0,directories=0,status=0');
  
  generatePinterestUrl:->
    baseUrl = '//pinterest.com/pin/create/button/?url='
    @targetUrl = @model.get('product_url')
    @targetUrl = "http://mywebroom.com" if !@targetUrl
    if @model.get('image_name_selection')
      #This is an items-design
      mediaUrl = @model.get('image_name_selection').url
      @targetUrl = Mywebroom.State.get('shopBaseUrl').itemDesign + @model.get('id')
      description = @model.get('name') + ' - '
      signature = ' - Found at myWebRoom.com'
    else if @model.get('image_name_desc')
      #this is a bookmark
      mediaUrl = @model.get('image_name_desc').url
      @targetUrl = Mywebroom.State.get('shopBaseUrl').bookmark
      description = @model.get('title') + ' - '
      signature = ' - For my virtual room at myWebRoom.com'
    else
      #IDK what this is
      mediaUrl = @model.get('image_name').url
      @targetUrl = Mywebroom.State.get('shopBaseUrl').default
      signature = ' - Found at myWebRoom.com'
    if !@targetUrl or !mediaUrl
      #something is wrong and we can't pin. 
      console.log "Error with Pinterest Parameters."
      return false
    description += @model.get('description')+ signature
    pinterestUrl = baseUrl + encodeURIComponent(@targetUrl) +
            '&media=' + encodeURIComponent(mediaUrl) +
            '&description=' + encodeURIComponent(description)
  generateFacebookURL:->
    if @model.get('image_name_selection')
      return  Mywebroom.State.get('shopBaseUrl').itemDesign + @model.get('id')
    else if @model.get('image_name_desc')
      return  Mywebroom.State.get('shopBaseUrl').bookmark
    else
      return Mywebroom.State.get('shopBaseUrl').default
  
