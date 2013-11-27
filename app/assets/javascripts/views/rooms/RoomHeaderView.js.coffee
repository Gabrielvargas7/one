class Mywebroom.Views.RoomHeaderView extends Backbone.View

  #*******************
  #**** Tag  (no tag = default el "div")
  #*******************

  #*******************
  #**** Template
  #*******************

  template: JST['rooms/RoomHeaderTemplate']



  #*******************
  #**** Events
  #*******************

  events: {
    'click #xroom_header_active_sites'   : 'showActiveSites'
    'click #xroom_header_profile'        : 'showProfile'
    'click #xroom_header_forward_profile': 'forwardToRoRProfilePage'
    'click #xroom_header_forward_setting': 'forwardToRoRSettingPage'
    'click #xroom_header_forward_help'   : 'forwardToRoRHelpPage'

    'click #xroom_header_logout'         : 'logout'

    'click #xroom_header_storepage'      : 'toggleStore'

    'click #xroom_header_myroom'         : 'goToMyRoom'
    'keyup #xroom_header_search_text'    : 'keyPressOnSearch'
    'focusout #xroom_header_search_text' : 'focusOutSearchTextBox'

    'click #header-search-dropdown li a' : 'headerSearchDropdownChange'     # SEARCH DROPDOWN
    'click #xroom_header_logo'           : 'goToMyRoom'

    'mouseenter #xroom_header_profile': 'hoverHeaderProfile'
    'mouseleave #xroom_header_profile': 'hoverOffHeaderProfile'

    'mouseenter #xroom_header_storepage': 'hoverHeaderStorePage'
    'mouseleave #xroom_header_storepage': 'hoverOffHeaderStorePage'

    'mouseenter #xroom_header_active_sites': 'hoverHeaderActiveSites'
    'mouseleave #xroom_header_active_sites': 'hoverOffHeaderActiveSites'
  }




  #*******************
  #**** Initialize
  #*******************

  initialize: ->

    @model = Mywebroom.State.get("roomData")


  #*******************
  #**** Render
  #*******************
  render: ->

    if Mywebroom.State.get("signInState")
      user_data = Mywebroom.State.get("signInData")

    else
      user_data = Mywebroom.State.get("roomData")


    mywebroom_logo = Mywebroom.State.get('staticContent').findWhere({"name":"mywebroom-logo"})
    # THIS VIEW
    $(@el).append(@template({user_data: user_data,mywebroom_logo:mywebroom_logo}))

    # add profile image to the header
    Mywebroom.Helpers.RoomHeaderHelper.addHeaderImageProfile()
    Mywebroom.Helpers.RoomHeaderHelper.addHeaderImageStorePage()
    Mywebroom.Helpers.RoomHeaderHelper.addHeaderImageActiveSites()






    # STORE VIEW
    @createStorePage()




    # PROFILE VIEW
    @createProfileView()



    # ADJUST HEADER
    @removeRoomHeaderElemments()


    Mywebroom.State.set("searchViewArray", [])


    this





  #*******************
  #**** Functions header
  #*******************


  #--------------------------
  #  *** function remove header elemenst
  #--------------------------
  removeRoomHeaderElemments: ->

    roomState =   Mywebroom.State.get("roomState")
    signInState = Mywebroom.State.get("signInState")

    if roomState isnt "SELF"
      $('#xroom_header_active_sites').remove()
      $('#xroom_header_storepage').remove()


    if roomState is "PUBLIC"
      $('#xroom_header_profile').remove()
      $('.dropdown').remove() if signInState isnt true
      @showProfile(null)

    if roomState is "FRIEND"
      @showProfile(null)

    $('#xroom_header_myroom').remove() if signInState isnt true



  #*******************
  #**** Functions get Collection data
  #*******************

  #--------------------------
  # get the user room info
  #--------------------------
  getUserSignInDataCollection: (userId) ->

    @userAllRoomDataCollection = new Mywebroom.Collections.ShowRoomByUserIdCollection()
    @userAllRoomDataCollection.fetch({
      async: false
      url  : @userAllRoomDataCollection.url(userId)
    })






  #*******************
  #**** Functions Profile
  #*******************

  #--------------------------
  #  *** function showProfile
  #--------------------------
  showProfile: (event) ->

    if event  # this is is because this fuction is also called when room is PUBLIC
      event.preventDefault()
    #If profile is not open
    if $('#xroom_profile:hidden').length > 0
      @displayProfile()
      #if its collapsed, uncollapse it
      if @profileView.collapseFlag is false
        @profileView.collapseProfileView()
    else
      @hideProfile()





  createProfileView: ->

    @profile = new Backbone.Model()
    @profile.set(@model.get('user_profile'))
    @profile.set('user', @model.get('user'))
    @profile.set('user_photos', @model.get('user_photos'))
    @profile.set('user_items_designs', @model.get('user_items_designs'))

    @profileView = new Mywebroom.Views.ProfileHomeView(
      {
        model         : @profile,
        roomHeaderView: this
      }
    )

    $('#xroom_profile').html(@profileView.el)
    @profileView.render()
    $('#xroom_profile').hide()
    Mywebroom.State.set('profileHomeView',@profileView)





  #*******************
  #**** Functions the forward to RoR
  #*******************

  #--------------------------
  #  *** function forwardToRoRProfilePage this function work on RoR, we should change to Backbone
  #--------------------------
  forwardToRoRProfilePage: (event) ->

    event.preventDefault()

    origin =  window.location.origin
    origin += "/users_profiles/edit_users_profiles_by_user_id/" + Mywebroom.State.get("signInUser").get("id")


    window.location.replace(origin)

  #--------------------------
  #  *** function  forwardToRoRSettingPage
  #--------------------------
  forwardToRoRSettingPage:(event) ->

    event.preventDefault()

    origin =  window.location.origin
    origin += "/users/" + Mywebroom.State.get("signInUser").get("id") + "/edit"

    window.location.replace(origin)


  forwardToRoRHelpPage:(event) ->
    event.preventDefault()

    origin =  window.location.origin
    origin += "/help"
    window.location.replace(origin)




  #*******************
  #**** Functions the to logout and forward to RoR home
  #*******************

  #--------------------------
  #  *** function createCookies
  #--------------------------
  createCookie: (name, value, days) ->

    if days
      date = new Date()
      date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000))
      expires = "; expires=" + date.toGMTString()
    else
      expires = ""

    document.cookie = name + "=" + value + expires + "; path=/"


  #--------------------------
  #  *** function eraseCookies
  #--------------------------
  eraseCookie: (name) ->

    this.createCookie(name, "", -1)


  #--------------------------
  #  *** function logout
  #--------------------------
  logout: (event) ->

    event.preventDefault()

    origin = window.location.origin

    this.eraseCookie("remember_token")
    window.location.href = origin



  #*******************
  #**** Functions StorePage
  #*******************

  #--------------------------
  #  *** function
  #--------------------------
  toggleStore: (e) ->

    e.preventDefault()
    e.stopPropagation()

    state = Mywebroom.State.get("storeState")

    switch state

      when "hidden"
        Mywebroom.Helpers.showStore()




      when "shown"
        ###
        Display a confirm dialog if there are any un-saved changes
        ###
        if $("[data-design-has-changed=true]").size() > 0 or $("[data-theme-has-changed=true]").size() > 0

          bootbox.confirm("Leaving this screen will not save your changes", (result) ->

            if result

              # Change All DOM properties back to their original
              Mywebroom.Helpers.cancelChanges()


              # Proceed with hiding the store
              Mywebroom.Helpers.hideStore()
          )
        else

          # Hide the store
          Mywebroom.Helpers.hideStore()




      when "collapsed"
        Mywebroom.Helpers.expandStore()


    # Always take these actions
    $('#xroom_profile').hide()
    $('#xroom_bookmarks').hide()
    $('#xroom_header_search_box').hide()
    @hideActiveSites()






  #--------------
  # --- STORE ---
  #--------------
  createStorePage: ->

    @storeLayoutView = new Mywebroom.Views.StoreLayoutView()
    $('#xroom_storepage').html(@storeLayoutView.el)
    @storeLayoutView.render()

    # Save a reference to the state model
    Mywebroom.State.set("storePageView", @storeLayoutView)

    $('#xroom_storepage').hide()
    $('#xroom_store_menu_save_cancel_remove').hide()




  #--------------------------
  #  *** function display
  #--------------------------
  displayProfile: ->

    $('#xroom_store_menu_save_cancel_remove').hide()
    $('#xroom_storepage').hide()
    $('#xroom_profile').show()
    $('#xroom_bookmarks').hide()
    $('#xroom_header_search_box').hide()
    @hideActiveSites()

    #Turn off events:

    #1. Image Hover: on or off
    Mywebroom.Helpers.turnOffHover()

    #2. Image Click: on or off
    Mywebroom.Helpers.turnOffDesignClick()

    #3. Scroller visibility
    $("#xroom_scroll_left").hide()
    $("#xroom_scroll_right").hide()




  hideProfile: ->
    @profileView.closeProfileView() if @profileView
    #Turn on events are in profileView.closeProfileView()



  displaySearchPage: ->

    $('#xroom_store_menu_save_cancel_remove').hide()
    $('#xroom_storepage').hide()

    if Mywebroom.State.get("roomState") is "SELF" then $('#xroom_profile').hide()

    $('#xroom_bookmarks').hide()
    $('#xroom_header_search_box').show()

    @hideActiveSites()





  #--------------------------
  #  *** function
  #--------------------------
  removeHeaderEvents: ->

    $(this.el).off('click', '#xroom_header_storepage')
    $(this.el).off('click', '#xroom_header_profile')
    $('.room_user_item_design_container').off()



  #*******************
  #**** Functions MyRoom
  #*******************

  goToMyRoom: (event) ->

    event.preventDefault()
    event.stopPropagation()

    if Mywebroom.State.get("signInUser")
      origin =  window.location.origin
      origin += '/room/' + Mywebroom.State.get("signInUser").get("username")

      window.location.replace(origin)
    else
      origin =  window.location.origin
      window.location.replace(origin)



  #*******************
  #**** Functions Search
  #*******************


  focusOutSearchTextBox: (event) ->

    event.preventDefault()
    event.stopPropagation()

    #console.log("clean textbox values")

    @hideCleanSearchBox()




  hideCleanSearchBox: ->

    $('#xroom_header_search_box').delay(500).hide(0)
    $('#xroom_header_search_text').delay(500).val("")





  slowDown:

    _.debounce( (keyCode) ->

      ###
      (1) Destroy Search View
      ###
      @destroySearchView()


      ###
      (2) Empty
      ###
      this.$('.search-wrapper').empty()


      ###
      (3) Capture value of search text
      ###
      val = $('#xroom_header_search_text').val().trim()


      ###
      (4) Capture value of search filter
      ###
      btn = $('#header-search-dropdown-btn').text()


      ###
      (5) Hide other views / show search results view
      ###
      @displaySearchPage()


      ###
      (6) Actually perform search
      ###
      if val and val.length > 0
        @insertSearchEntityView(val, btn)



      # Highlight the first one
      #$('[data-search-id=0]').trigger('mouseenter')


      # If there aren't any search results, hide the box
      if $('.search-container').length is 0 then $('#xroom_header_search_box').hide()



    , 500)





  keyPressOnSearch: (event) ->


    ###
    SEARCH LOGIC GETS WRAPPED IN DEBOUNCE FUNCTION
    ###
    if event.keyCode is 40 # <-- DOWN


      if $('#xroom_header_search_box').is(':visible')

        ###
        Is there another search result?
        ###
        unless $('[data-search-id=' + (Mywebroom.Data.searchNum + 1) + ']').length is 0

          # (1) Enter Next
          $('[data-search-id=' + (Mywebroom.Data.searchNum + 1) + ']').trigger('mouseenter')

          # (2) Scroll
          try
            #$('[data-search-id=' + (Mywebroom.Data.searchNum + 1) + ']').scrollTo(200)
            $('.search-container')[Mywebroom.Data.searchNum].scrollIntoView()
          catch error
            #alert("error #1")




        else

          ###
          WE'VE REACHED THE END OF OUR SEARCH RESULTS - GO BACK TO THE START
          ###

          # (1) Enter First
          $('[data-search-id=0]').trigger('mouseenter')

          # (2) Scroll
          try
            #$('[data-search-id=0]').scrollTo(200)
            $('.search-container')[0].scrollIntoView()
          catch error
            #alert("error #2")






    else if event.keyCode is 38 # <-- UP

      if $('#xroom_header_search_box').is(':visible')

        ###
        Check for previous search containers
        ###
        unless $('[data-search-id=' + (Mywebroom.Data.searchNum - 1) + ']').length is 0

          # (1) Enter Previous
          $('[data-search-id=' + (Mywebroom.Data.searchNum - 1) + ']').trigger('mouseenter')

          # (2) Scroll
          try
            #$('[data-search-id=' + (Mywebroom.Data.searchNum - 1) + ']').scrollTo(200)
            $('.search-container')[Mywebroom.Data.searchNum].scrollIntoView()
          catch error
            #alert("error #3")



    else if event.keyCode is 13 # <-- ENTER


      if $('#xroom_header_search_box').is(':visible')

        ###
        Trigger the click event on the container
        unless the user hasn't entered a search container
        ###
        unless Mywebroom.Data.searchNum is -1
          $('[data-search-id=' + Mywebroom.Data.searchNum + ']').trigger('click')




    else

      ###
      Capture value of search text
      ###
      val = $('#xroom_header_search_text').val()


      ###
      Perform search when text isn't empty
      ###
      if val.trim() isnt ""

        @slowDown(event.keyCode)

      else

        ###
        If it is empty, clear the results
        ###
        @destroySearchView()
        this.$('.search-wrapper').empty()
        $('#xroom_header_search_box').hide()








  insertSearchEntityView: (value,valueSearchBtn) ->

    i = 0
    switch valueSearchBtn
      when 'ALL'
        searchUsersCollection =         @getSearchUserCollection(value)
        searchItemDesignsCollection =   @getSearchItemDesignsCollection(value)
        searchBookmarksCollection =     @getSearchBookmarksCollection(value)
        item_length = searchItemDesignsCollection.length
        user_length = searchUsersCollection.length
        bookmark_length = searchBookmarksCollection.length

        i = 0
        if item_length > user_length
          i = item_length
          if bookmark_length > item_length
            i = bookmark_length
        else
          i = user_length
          if bookmark_length > user_length
            i = bookmark_length


      when 'OBJECTS'
        searchItemDesignsCollection =  @getSearchItemDesignsCollection(value)
        i = searchItemDesignsCollection.length

      when 'BOOKMARKS'
        searchBookmarksCollection =  @getSearchBookmarksCollection(value)
        i = searchBookmarksCollection.length
      when 'PEOPLE'
        searchUsersCollection =  @getSearchUserCollection(value)
        i = searchUsersCollection.length


    #console.log("set Data Collection")
    #console.log(searchUsersCollection)
    #console.log(searchItemDesignsCollection)
    #console.log(searchBookmarksCollection)

    g = 0
    self = this
    @number_views = 0
    search_view_array  = Mywebroom.State.get("searchViewArray")
    while (g < i)
      #console.log("loop Data Collection")
      #console.log(searchItemDesignsCollection.at(g))
      #console.log(searchUsersCollection.at(g))



      if searchUsersCollection is undefined
        searchUsersModel = undefined
      else
        searchUsersModel =  searchUsersCollection.at(g)


      if searchItemDesignsCollection is undefined
        searchItemDesignsModel = undefined
      else
        searchItemDesignsModel =  searchItemDesignsCollection.at(g)


      if searchBookmarksCollection is undefined
        searchBookmarksModel = undefined
      else
        searchBookmarksModel =  searchBookmarksCollection.at(g)


      # add user to the search view
      if searchUsersModel is undefined
        #console.log("---")
        #console.log(" undefined "+g.toString())
      else
        #console.log("---")
        #console.log("Not undefined "+g.toString())

        entityModel  = new Mywebroom.Models.BackboneSearchEntityModel()
        entityModel.set('entityType',Mywebroom.Models.BackboneSearchEntityModel.PEOPLE)
        entityModel.set('displayTopName',searchUsersModel.get('firstname') + ' ' + searchUsersModel.get('lastname'))
        entityModel.set('imageName',searchUsersModel.get('image_name').url)
        entityModel.set('entityId',searchUsersModel.get('user_id'))
        entityModel.set('displayUnderName',searchUsersModel.get('username'))
        entityModel.set('viewNum',self.number_views)

        #      console.log(entityModel)

        view = new Mywebroom.Views.SearchEntityView({model:entityModel})
        this.$('.search-wrapper').append(view.render().el)
        search_view_array[self.number_views] = view
        self.number_views += 1

      # add item designs to the search view
      #console.log("is undefines item designs model")
      #console.log(searchItemDesignsModel)
      if searchItemDesignsModel is undefined
        #console.log("---")
        #console.log(" undefined "+g.toString())
      else
        #console.log("---")
        #console.log("Not undefined "+g.toString())
        entityModel  = new Mywebroom.Models.BackboneSearchEntityModel()

        Mywebroom.Models.BackboneSearchEntityModel.ITEM_DESIGN
        entityModel.set('entityType',Mywebroom.Models.BackboneSearchEntityModel.ITEM_DESIGN)
        entityModel.set('displayTopName',searchItemDesignsModel.get('name'))
        entityModel.set('imageName',searchItemDesignsModel.get('image_name_selection').url)
        entityModel.set('entityId',searchItemDesignsModel.get('id'))
        entityModel.set('displayUnderName',Mywebroom.Models.BackboneSearchEntityModel.DISPLAY_UNDER_NAME_OBJECT)
        entityModel.set('viewNum',self.number_views)
        #      console.log(entityModel)

        view = new Mywebroom.Views.SearchEntityView({model:entityModel})
        this.$('.search-wrapper').append(view.render().el)
        search_view_array[self.number_views] = view
        self.number_views += 1

      # add user to the search view
      if searchBookmarksModel is undefined
        #console.log("---")
        #console.log(" undefined "+g.toString())
      else
        #console.log("---")
        #console.log("Not undefined "+g.toString())

        entityModel  = new Mywebroom.Models.BackboneSearchEntityModel()
        entityModel.set('entityType',Mywebroom.Models.BackboneSearchEntityModel.BOOKMARK)
        entityModel.set('displayTopName',searchBookmarksModel.get('title'))
        entityModel.set('imageName',searchBookmarksModel.get('image_name_desc').url)
        entityModel.set('entityId',searchBookmarksModel.get('id'))
        entityModel.set('displayUnderName',Mywebroom.Models.BackboneSearchEntityModel.DISPLAY_UNDER_NAME_BOOKMARK)
        entityModel.set('viewNum',self.number_views)
        #   console.log(entityModel)

        view = new Mywebroom.Views.SearchEntityView({model:entityModel})
        this.$('.search-wrapper').append(view.render().el)
        search_view_array[self.number_views] = view
        self.number_views += 1


      g += 1








  destroySearchView: ->

    search_view_array  = Mywebroom.State.get("searchViewArray")
    _.each(search_view_array, (view) ->
      view.remove()
      view.unbind()
    )




  getSearchUserCollection:(value) ->

    searchUsers = new Mywebroom.Collections.IndexSearchesUsersProfileWithLimitAndOffsetAndKeywordCollection()
    searchUsers.fetch({
      async  : false
      url    : searchUsers.url(20, 0, value)
      success: ->
        #console.log("print user profile collection on json format")
        #console.log(searchUsers.toJSON())
        #console.log("- JSON.stringify "+JSON.stringify(searchUsers))
      error: ->
        #console.log("error")
    })
    searchUsers




  getSearchItemDesignsCollection:(value) ->

    searchItemDesignsCollection = new Mywebroom.Collections.IndexSearchesItemsDesignsWithLimitAndOffsetAndKeywordCollection()
    searchItemDesignsCollection.fetch({
      async  : false
      url    : searchItemDesignsCollection.url(20, 0, value)
      success: ->
        #console.log("print item designs collection on json format")
        #console.log(searchItemDesignsCollection.toJSON())
        #console.log("- JSON.stringify "+JSON.stringify(searchUsers))
      error: ->
        #console.log("error")
    })
    searchItemDesignsCollection




  getSearchBookmarksCollection:(value) ->

    searchBookmarksCollection = new Mywebroom.Collections.IndexSearchesBookmarksWithLimitAndOffsetAndKeywordCollection()
    searchBookmarksCollection.fetch({
      async  : false
      url    : searchBookmarksCollection.url(20, 0, value)
      success: ->
        #console.log("print bookmarks collection on json format")
        #console.log(searchBookmarksCollection.toJSON())
        #console.log("- JSON.stringify "+JSON.stringify(searchUsers))
      error: ->
        #console.log("error")
    })
    searchBookmarksCollection


  #*******************
  #**** Functions change the search filter
  #*******************
  headerSearchDropdownChange: (e) ->

    # SEARCH DROPDOWN
    # Remove active class
    #console.log("header bth")
    $('#header-search-dropdown li').removeClass('active')


    # Add active class to just-clicked element
    $(e.target).parent().addClass('active')

    # Change the text of the search filter
    $('#header-search-dropdown-btn').text(e.target.text)





  #*******************
  #**** Functions Active Sites and Browse Mode
  #*******************

  showActiveSites:(event) ->

    event.stopPropagation()
    event.preventDefault()

    $('#xroom_store_menu_save_cancel_remove').hide()
    $('#xroom_storepage').hide()
    $('#xroom_profile').hide()
    $('#xroom_bookmarks').hide()
    $('#xroom_header_search_box').hide()

    #If no active sites, toast message
    if Mywebroom.State.get('activeSitesMenuView')
      if Mywebroom.State.get('activeSitesMenuView').collection.length > 0
        #show
        Mywebroom.State.get('activeSitesMenuView').showActiveMenu()
        $('.browse_mode_view').show()
        $('#xroom_bookmarks_browse_mode').show()
      else
        @noActiveSitesToast()
    else
      @noActiveSitesToast()




  hideActiveSites: ->

    $('#xroom_bookmarks_browse_mode').hide()
    $('#browse_mode_item_name').remove()




  noActiveSitesToast: ->

    # Note, SN created class called toast-top-center to position toast appropriately.
    toastr.options = {
      "closeButton":     true
      "debug":           false
      "positionClass":   "toast-top-center"
      "onclick":         null
      "showDuration":    "0"
      "hideDuration":    "0"
      "timeOut":         "3000"
      "extendedTimeOut": "0"
      "showEasing":      "swing"
      "hideEasing":      "linear"
      "showMethod":      "fadeIn"
      "hideMethod":      "fadeOut"
    }
    # Display the Toastr message
    toastr.info("There are no active sites currently open. Click on an object to start surfing the web!")



  hoverHeaderProfile:(event) ->
    event.stopPropagation()
    event.preventDefault()
    Mywebroom.Helpers.RoomHeaderHelper.addHoverHeaderImageProfile()



  hoverOffHeaderProfile:(event) ->
    event.stopPropagation()
    event.preventDefault()
    Mywebroom.Helpers.RoomHeaderHelper.addHeaderImageProfile()



  hoverOffHeaderStorePage:(event) ->
    event.stopPropagation()
    event.preventDefault()
    Mywebroom.Helpers.RoomHeaderHelper.addHeaderImageStorePage()


  hoverHeaderStorePage:(event) ->
    event.stopPropagation()
    event.preventDefault()
    Mywebroom.Helpers.RoomHeaderHelper.addHoverHeaderImageStorePage()



  hoverOffHeaderActiveSites:(event) ->
    event.stopPropagation()
    event.preventDefault()
    Mywebroom.Helpers.RoomHeaderHelper.addHeaderImageActiveSites()


  hoverHeaderActiveSites:(event) ->
    event.stopPropagation()
    event.preventDefault()
    Mywebroom.Helpers.RoomHeaderHelper.addHoverHeaderImageActiveSites()





