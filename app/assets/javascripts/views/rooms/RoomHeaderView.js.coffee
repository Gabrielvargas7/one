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
    'click #xroom_header_logout'         : 'logout'
    'click #xroom_header_storepage'      : 'showStorePage'
    'click #xroom_header_myroom'         : 'goToMyRoom'
    'keyup #xroom_header_search_text'    : 'keyPressOnSearch'
    'focusout #xroom_header_search_text' : 'focusOutSearchTextBox'
    'keydown #xroom_header_search_text'  : 'keyDownFireRecently'
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
    
    # THIS VIEW
    $(@el).append(@template(user_data: Mywebroom.State.get("roomData")))




    # STORE VIEW
    @createStorePage()
    
    
    
    
    # PROFILE VIEW
    @createProfileView()
    
    
    
    # ADJUST HEADER
    @removeRoomHeaderElemments()



    # Create Search Box
    searchView = new Mywebroom.Views.SearchView()
    $("#xroom_header_search_box").append(searchView.el)
    $("#xroom_header_search_box").hide()
    searchView.render()
    @searchViewArray = new Array()
    Mywebroom.State.set("searchViewArray", @searchViewArray)



    this





  #*******************
  #**** Functions header
  #*******************

    
  #--------------------------
  #  *** function remove header elemenst
  #--------------------------
  removeRoomHeaderElemments: ->
    roomState   = Mywebroom.State.get("roomState")
    signInState = Mywebroom.State.get("signInState")
    
    
    $('#xroom_header_storepage').remove() if roomState isnt "SELF"
      

    if roomState is "PUBLIC"
      $('#xroom_header_profile').remove()
      $('.dropdown').remove()
      @showProfile(null)


    $('#xroom_header_myroom').remove() if signInState isnt true
      


  #*******************
  #**** Functions get Collection data
  #*******************

  #--------------------------
  # get the user room info
  #--------------------------
  getUserSignInDataCollection:(userId) ->
    @userAllRoomDataCollection = new Mywebroom.Collections.ShowRoomByUserIdCollection()
    @userAllRoomDataCollection.fetch
      async: false
      url  : @userAllRoomDataCollection.url userId
      
      




  #*******************
  #**** Functions Profile
  #*******************

  #--------------------------
  #  *** function showProfile
  #--------------------------
  showProfile: (event) ->
    if event  # this is is because this fuction is also called when room is PUBLIC
      event.preventDefault()
    
    @displayProfile()







  createProfileView:->
    
    @profile = new Backbone.Model
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





  #*******************
  #**** Functions the forward to RoR
  #*******************

  #--------------------------
  #  *** function forwardToRoRProfilePage this function work on RoR, we should change to Backbone
  #--------------------------
  forwardToRoRProfilePage:(event) ->
    
    event.preventDefault()
   
    origin =  window.location.origin
    origin += "/users_profiles/show_users_profiles_by_user_id/" + @model.get('user').id
    
    window.location.replace(origin)


  #--------------------------
  #  *** function  forwardToRoRSettingPage
  #--------------------------
  forwardToRoRSettingPage:(event) ->
    
    event.preventDefault()
  
    origin =  window.location.origin
    origin += "/users/" + @model.get('user').id
   
    # Why do we use set location.href instead of calling location.replace() ??
    window.location.href = origin




  #*******************
  #**** Functions the to logout and forward to RoR home
  #*******************

  #--------------------------
  #  *** function createCookies
  #--------------------------
  createCookie: (name, value, days) ->
    if days
      date = new Date()
      date.setTime date.getTime() + (days * 24 * 60 * 60 * 1000)
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
   
    this.eraseCookie "remember_token"
    window.location.href = origin



  #*******************
  #**** Functions StorePage
  #*******************

  #--------------------------
  #  *** function
  #--------------------------
  showStorePage: (event) ->
    if event  # This is because this fuction is also called when room is PUBLIC
      event.preventDefault()
      event.stopPropagation()
   
    @displayStorePage()





  #--------------
  # --- STORE ---
  #--------------
  createStorePage:->
    
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
  displayStorePage: ->
    
    
    # Show the store div
    $('#xroom_storepage').show()
    
    
    
    
    
    
    
    # Now that we're showing the store,
    # we need to show the hidden images
    # in the user's room
    $("[data-room-hide=yes]").show()
    
    
    
    grey =
      1 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826528/bed_grey.png"             # Bed
      2 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826555/brid_cage_grey.png"       # Bird Cage
      3 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826571/book_stand_grey.png"      # Book Shelve (sic)
      4 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826593/chair_grey.png"           # Chair
      5 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826708/newspaper_grey.png"       # Newspaper
      6 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826862/world_map_grey.png"       # World Map
      7 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826837/tv_stand_grey.png"        # TV Stand
      8 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826663/file_box_grey.png"        # File Box
      9 : "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826799/shopping_bag_grey.png"    # Shopping Bag
      10: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826815/social_painting_grey.png" # Social Painting
      11: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826648/encylco_shelf_grey.png"   # Encyclo Shelf
      12: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826687/music_box_grey.png"       # Music Box
      13: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826845/tv_grey.png"              # TV
      14: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826633/desk_grey.png"            # Desk
      15: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826721/night_stand_grey.png"     # Night Stand
      16: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826732/notebook_grey.png"        # Notebook
      17: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826603/computer_grey.png"        # Computer
      18: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826751/phone_grey.png"           # Phone
      19: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826675/lamp_grey.png"            # Lamp
      20: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826768/pinboard_grey.png"        # Pinboard
      21: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826784/portrait_grey.png"        # Portrait
      22: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826826/sports_grey.png"          # Sports
      23: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826616/curtain_grey.png"         # Curtain
      24: "//res.cloudinary.com/hpdnx5ayv/image/upload/v1380826583/box_grey.png"             # Box
      25: "//upload.wikimedia.org/wikipedia/commons/thumb/1/18/Grey_Square.svg/150px-Grey_Square.svg.png"                     # Games -- FIXME -- not correct image
    
    
    # And now we need replace src with above
    $('[data-room-hide=yes]').each ->
      $(@).attr("src", grey[$(@).data("room_item_id")])
    
    
    
    
    
    
    
    
    $('#xroom_profile').hide()
    $('#xroom_bookmarks').hide()
    $('#xroom_header_search_box').hide()
    @hideActiveSites()
    
    
    
    
    ###
    TODO
    (1) Click the OBJECTS tab <-- DONE
    (2) Remvove scrollbars    <-- DONE
    (3) Turn off hover events for images on the page
    ###
    
    # Click OBJECTS tab
    $('#storeTabs a[href="#tab_items"]').tab('show')
    
    
    Mywebroom.State.get("roomScrollLeftView").remove()
    Mywebroom.State.get("roomScrollRightView").remove()
    
    
    Mywebroom.State.set("roomScrollLeftView", false)
    Mywebroom.State.set("roomScrollRightView", false)
    


  #--------------------------
  #  *** function
  #--------------------------
  displayProfile: ->
    $('#xroom_store_menu_save_cancel_remove').hide()
    $('#xroom_storepage').hide()
    $('#xroom_profile').show()
    $('#xroom_bookmarks').hide()
    $('#xroom_header_search_box').hide()
    @hideActiveSites()



  displaySearchPage: ->
    $('#xroom_store_menu_save_cancel_remove').hide()
    $('#xroom_storepage').hide()
    $('#xroom_profile').hide()
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

    origin =  window.location.origin
    origin += '/room/' + Mywebroom.State.get("signInUser").get("username")
   
    window.location.replace(origin)


  #*******************
  #**** Functions Search
  #*******************


  focusOutSearchTextBox:(event)->
    event.preventDefault()
    event.stopPropagation()
    console.log("clean textbox values")
#    _.debounce(@hideCleanSearchBox(), 1300);




  hideCleanSearchBox:->
    $('#xroom_header_search_box').hide()
    $('#xroom_header_search_text').val("")


  keyPressOnSearch:(event)->
    event.preventDefault()
    event.stopPropagation()

    console.log(event.type, event.keyCode)

    this.destroySearchView()
    this.$('.header_search_wrapper').empty()


    if  event.keyCode == 13
      $('#xroom_header_search_box').hide()
      console.log("do something")

    else

      @displaySearchPage()
      console.log("value "+$('#xroom_header_search_text').val())
      value = $('#xroom_header_search_text').val()

      if value != ""
#        _.debounce(@insertSearchEntityView(value), 300);
        @insertSearchEntityView(value)



  insertSearchEntityView:(value)->
        searchUsersCollection =  @getSearchUserCollection(value)
        searchItemDesignsCollection =  @getSearchItemDesignsCollection(value)
        searchBookmarksCollection =  @getSearchBookmarksCollection(value)

        console.log("set Data Collection")
        console.log(searchUsersCollection)
        console.log(searchItemDesignsCollection)
        console.log(searchBookmarksCollection)

        item_length = searchItemDesignsCollection.length
        user_length = searchUsersCollection.length
        bookmark_length = searchBookmarksCollection.length

        i = 0
        if item_length > user_length
           i = item_length
           if bookmark_length> item_length
             i = bookmark_length
        else
           i = user_length
           if bookmark_length> user_length
            i = bookmark_length
        g = 0
        self = this
        @number_views = 0
        search_view_array  = Mywebroom.State.get("searchViewArray")
        while (g<i)
          console.log("loop Data Collection")
#          console.log(searchItemDesignsCollection.at(g))
#          console.log(searchUsersCollection.at(g))


          searchUsersModel =  searchUsersCollection.at(g)
          searchItemDesignsModel =  searchItemDesignsCollection.at(g)
          searchBookmarksModel =  searchBookmarksCollection.at(g)


          # add user to the search view
          if searchUsersModel is undefined
              console.log("---")
              console.log(" undefined "+g.toString())
          else
              console.log("---")
              console.log("Not undefined "+g.toString())

              entityModel  = new Mywebroom.Models.BackboneSearchEntityModel()
              entityModel.set('entityType',Mywebroom.Models.BackboneSearchEntityModel.PEOPLE)
              entityModel.set('displayTopName',searchUsersModel.get('firstname')+' '+searchUsersModel.get('lastname'))
              entityModel.set('imageName',searchUsersModel.get('image_name').url)
              entityModel.set('entityId',searchUsersModel.get('user_id'))
              entityModel.set('displayUnderName',searchUsersModel.get('username'))
              entityModel.set('viewNum',self.number_views)

              #      console.log(entityModel)

              view = new Mywebroom.Views.SearchEntityView({model:entityModel})
              this.$('.header_search_wrapper').append(view.render().el)
              search_view_array[self.number_views] = view
              self.number_views++

          # add item designs to the search view
          if searchItemDesignsModel is undefined
            console.log("---")
            console.log(" undefined "+g.toString())
          else
            console.log("---")
            console.log("Not undefined "+g.toString())
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
            this.$('.header_search_wrapper').append(view.render().el)
            search_view_array[self.number_views] = view
            self.number_views++

          # add user to the search view
          if searchBookmarksModel is undefined
            console.log("---")
            console.log(" undefined "+g.toString())
          else
            console.log("---")
            console.log("Not undefined "+g.toString())

            entityModel  = new Mywebroom.Models.BackboneSearchEntityModel()
            entityModel.set('entityType',Mywebroom.Models.BackboneSearchEntityModel.BOOKMARK)
            entityModel.set('displayTopName',searchBookmarksModel.get('title'))
            entityModel.set('imageName',searchBookmarksModel.get('image_name_desc').url)
            entityModel.set('entityId',searchBookmarksModel.get('id'))
            entityModel.set('displayUnderName',Mywebroom.Models.BackboneSearchEntityModel.DISPLAY_UNDER_NAME_BOOKMARK)
            entityModel.set('viewNum',self.number_views)
            #   console.log(entityModel)

            view = new Mywebroom.Views.SearchEntityView({model:entityModel})
            this.$('.header_search_wrapper').append(view.render().el)
            search_view_array[self.number_views] = view
            self.number_views++


          g++









  destroySearchView:->
    search_view_array  = Mywebroom.State.get("searchViewArray")
    _.each(search_view_array, (view)->
      view.remove()
      view.unbind()
    )




  getSearchUserCollection:(value)->
    searchUsers = new Mywebroom.Collections.IndexSearchesUsersProfileWithLimitAndOffsetAndKeywordCollection()
    searchUsers.fetch
      async  : false
      url    : searchUsers.url(10,0,value)
      success: ->
        console.log("print user profile collection on json format")
        console.log(searchUsers.toJSON())
#        console.log("- JSON.stringify "+JSON.stringify(searchUsers))
      error: ->
        console.log("error")
    searchUsers


  getSearchItemDesignsCollection:(value)->
    searchItemDesignsCollection = new Mywebroom.Collections.IndexSearchesItemsDesignsWithLimitAndOffsetAndKeywordCollection()
    searchItemDesignsCollection.fetch
      async  : false
      url    : searchItemDesignsCollection.url(10,0,value)
      success: ->
        console.log("print item designs collection on json format")
        console.log(searchItemDesignsCollection.toJSON())
#        console.log("- JSON.stringify "+JSON.stringify(searchUsers))
      error: ->
        console.log("error")
    searchItemDesignsCollection

  getSearchBookmarksCollection:(value)->
    searchBookmarksCollection = new Mywebroom.Collections.IndexSearchesBookmarksWithLimitAndOffsetAndKeywordCollection()
    searchBookmarksCollection.fetch
      async  : false
      url    : searchBookmarksCollection.url(10,0,value)
      success: ->
        console.log("print bookmarks collection on json format")
        console.log(searchBookmarksCollection.toJSON())
#        console.log("- JSON.stringify "+JSON.stringify(searchUsers))
      error: ->
        console.log("error")
    searchBookmarksCollection





  #*******************
  #**** Functions Active Sites and Browse Mode
  #*******************

  showActiveSites:(event)->
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

  hideActiveSites:->
    $('#xroom_bookmarks_browse_mode').hide()
    $('#browse_mode_item_name').remove()

  noActiveSitesToast:->
    #Note, SN created class called toast-top-center to position toast appropriately.
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






