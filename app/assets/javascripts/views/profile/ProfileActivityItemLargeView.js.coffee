class Mywebroom.Views.ActivityItemLargeView extends Backbone.View

  template: JST['profile/ProfileActivityItemLargeTemplate']

  className: 'activity_item_large_wrap'

  initialize: ->

    #1. Set events to close the view when clicked outside profile Activity.

    _.bindAll this, 'insideHandler', 'outsideHandler'
    @originalCollection = this.options.originalCollection
    $('body').on('click', this.outsideHandler)

    #2. Add transition to profile_drawer
    $('#profile_drawer').css('transition','all 1s ease-in-out')

    #Photos Only Code vs. Other Types
    if @model.collection.constructor.name is Mywebroom.Collections.IndexUsersPhotosByUserIdByLimitByOffsetCollection.name
      @template = JST['profile/ProfilePhotosLargeTemplate']

    else
      @model.set('fbUrl', @generateFacebookURL())

  events: {
    'click #large_item_prev':                       'showNext'
    'click #large_item_next':                       'showNext'
    'click .profile_large_item_try_it_button':      'showStore'
    'click .gridItem':                              'closeView'
    'click .pinterest_item':                        'pinIt'
    'click #profile_photos_set_as_profile_picture': 'setAsProfilePicture'
  }

  render: ->

    $("#profile_drawer").css "width", "1320px"

    # user_profile is sent to template for the case that we are in Photos view
    $(@el).html(@template(model: @model, user_profile: Mywebroom.State.get('roomData').get('user_profile')))
    FB.XFBML.parse($(@el)[0])

    # The social View is in the template because
    # the styling was not right with this view.

    #Set State for LargeView tracker;
    Mywebroom.State.set('profileLargeView', this)

    this




  insideHandler: (event) ->

    event.stopPropagation()
    #console.log "insideHandler called"




  outsideHandler: (event) ->

    #console.log "outsideHandler called"
    #console.log(event)
    #If event src element is try in my room, close this view and open store.
    #if event src is next or prev, change model to next in collection.
    #else close view
    @closeView()
    return false




  setAsProfilePicture: (event) ->
    event.stopPropagation()




  closeView: ->

    $('body').off('click', this.outsideHandler)

    # Change profile_drawer widths back to original
    $("#profile_drawer").css "width", "760px"
    setTimeout (->
      $('#profile_drawer').css('transition', 'none')
      ),1000


    #Set State for LargeView tracker
    Mywebroom.State.set('profileLargeView', false)

    this.$el.remove()
    this




  closeViewNoProp: (event) ->

    event.stopPropagation()
    event.data.closeView()




  showNext: (event) ->

    event.stopPropagation()
    this.trigger('ProfileActivityLargeView:showNext', event, @model)




  showStore: (event) ->

    event.stopPropagation()
    #If room is not self, go to my room with params.

    ###
    URL Encoded Params

    entity_type: BOOKMARK, DESIGN, THEME, BUNDLE, ENTIRE_ROOM <-- model.get("type")
    entity_id  : i.e. 123 <-- model.get("id")
    came_from  : PUBLIC_SHOP, SEARCH, FRIEND, ?? <-- TODO
    item_id    : model.get("item_id") <-- should only need for bookmarks
    ###

    ###
    If user not signed in, send to landing page. Otherwise, send to their room with params.
    ###
    if !Mywebroom.State.get('signInUser')
     return window.location.assign(window.location.protocol + "//" + window.location.host)


    if Mywebroom.State.get('roomState') != "SELF"
      if @model.get('bookmark_url')
        #console.log 'this is a bookmark. add it to your collection!'
        #console.log @model
        #get userID, Item ID, BookmarkID
        helper = new Mywebroom.Helpers.ItemHelper()
        userId = helper.getUserId()
        #Post bookmark
        position = @getMyBookmarksLength(userId)

        # If position is 0 or the bookmark is not already in collection:
        if position is 0 or not @myBookmarksCollection.get(@model.id)
          postBookmarkModel = new Mywebroom.Models.CreateUserBookmarkByUserIdBookmarkIdItemId({itemId: @model.get('item_id'), bookmarkId: @model.get('id'), userId: userId})
          postBookmarkModel.set 'position', position + 1
          postBookmarkModel.save {},
            success: (model, response) ->
              #console.log('postBookmarkModel SUCCESS:')
              #console.log(response)
            error: (model, response) ->
              if response.responseText != "the bookmark already exists"
                console.error('postBookmarkModel FAIL:')
                console.error(response)

        # Added confirmation.
        #@$('.profile_large_item_try_it_button').append("<img src='http://res.cloudinary.com/hpdnx5ayv/image/upload/v1378226370/bookmarks-corner-icon-check-confirmation.png'>")
        @$('.profile_large_item_try_it_button').text("Added to your " + Mywebroom.Data.ItemNames[ parseInt( @model.get('item_id') ) ] + '!')
        @$('.profile_large_item_try_it_button').addClass('profile_large_item_tried_it').removeClass('profile_large_item_try_it_button')
      else
        #its an object/design
        paramType = "DESIGN"
        paramId = @model.get('id')

        #send to my room
        paramCameFrom = Mywebroom.State.get('roomState') + "_ROOM"
        parameters = parameters || $.param({'entity_type': paramType, 'entity_id': paramId,'came_from': paramCameFrom})

        window.location.href = window.location.protocol + "//" + window.location.host + '/room/' + Mywebroom.State.get('signInUser').get('username') + '?' + parameters


    else

      #if item is object, show store.
      #if item is bookmark add bookmark.
      if @model.get('bookmark_url')
        #console.log 'this is a bookmark. add it to your collection!'
        #console.log @model
        #get userID, Item ID, BookmarkID
        helper = new Mywebroom.Helpers.ItemHelper()
        userId = helper.getUserId()
        #Post bookmark
        position = @getMyBookmarksLength(userId)
        #CHeck if bookmark is here already:
        if !@myBookmarksCollection.get(@model.id)
          postBookmarkModel = new Mywebroom.Models.CreateUserBookmarkByUserIdBookmarkIdItemId({itemId:@model.get('item_id'), bookmarkId:@model.get('id'),userId:userId})
          postBookmarkModel.set 'position', position + 1
          postBookmarkModel.save {},
            success: (model, response) ->
              #console.log('postBookmarkModel SUCCESS:')
              #console.log(response)
            error: (model, response) ->
              if response.responseText != "the bookmark already exists"
                console.error('postBookmarkModel FAIL:')
                console.error(response)
        #Added confirmation.
        #@$('.profile_large_item_try_it_button').append("<img src='http://res.cloudinary.com/hpdnx5ayv/image/upload/v1378226370/bookmarks-corner-icon-check-confirmation.png'>")
        @$('.profile_large_item_try_it_button').text("Added to your " + Mywebroom.Data.ItemNames[ parseInt( @model.get('item_id') ) ] + '!')
        @$('.profile_large_item_try_it_button').addClass('profile_large_item_tried_it').removeClass('profile_large_item_try_it_button')
      else
        #console.log 'hide ya profile cause the store\'s comin out y\'all'
        #console.log @model

        $('#xroom_profile').hide()
        @closeView()


        # (1) Show Store
        Mywebroom.Helpers.EditorHelper.showStore()


        # (2) Switch to the hidden tab
        $('#storeTabs a[href="#tab_hidden"]').tab('show')


        # (3) Use model to populate view
        Mywebroom.State.get("storeMenuView").appendOne(@model)



  getMyBookmarksLength: (userId) ->

    @myBookmarksCollection = new Mywebroom.Collections.IndexUserBookmarksByUserIdAndItemIdCollection()
    @myBookmarksCollection.fetch
      async:false
      url:@myBookmarksCollection.url userId, @model.get('item_id')

    if @myBookmarksCollection.length > 0
      parseInt(_.last(@myBookmarksCollection.models).get('position'))
    else
      0





  pinIt: (event) ->

    event.preventDefault()
    event.stopPropagation()

    pinterestURL = @generatePinterestUrl()

    if pinterestURL
      window.open(pinterestURL,'_blank','width=750,height=350,toolbar=0,location=0,directories=0,status=0')




  generatePinterestUrl: ->

    if not @model.has('id')
      console.error('model without id', @model)


    if not @model.has('type')
      console.error('model without type', @model)



    type = @model.get('type')
    url = Mywebroom.Helpers.getSEOLink(@model.get('id'), type)


    baseUrl = '//pinterest.com/pin/create/button/?url='


    switch type

      when "DESIGN"
        mediaUrl =    @model.get('image_name_selection').url
        description = @model.get('name') + ' - '
        signature =   ' - Found at myWebRoom.com'

      when "BOOKMARK"
        mediaUrl =    @model.get('image_name_desc').url
        description = @model.get('title') + ' - '
        signature =   ' - For my virtual room at myWebRoom.com'

      when "ENTIRE_ROOM"
        mediaUrl = @model.get('image_name_set').url
        description = @model.get('name')
        signature = ' - Check out this virtual room at myWebRoom.com'

      when "BUNDLE"
        mediaUrl = @model.get('image_name')
        description = @model.get('name')
        signature = ' - For my virtual room at myWebRoom.com'

      when "THEME"
        mediaUrl = @model.get('image_name_selection')
        description = @model.get('name')
        signature = ' - For my virtual room at myWebRoom.com'



    description += @model.get('description') + signature
    results = baseUrl +
              encodeURIComponent(url.get("seo_url")) +
              '&media=' +
              encodeURIComponent(mediaUrl) +
              '&description=' +
              encodeURIComponent(description)


    return results




  generateFacebookURL: ->

    baseUrl = 'https://www.facebook.com/sharer/sharer.php?u='
    url = Mywebroom.Helpers.getSEOLink(@model.get('id'), @model.get('type'))

    return baseUrl + encodeURIComponent(url.get("seo_url"))
