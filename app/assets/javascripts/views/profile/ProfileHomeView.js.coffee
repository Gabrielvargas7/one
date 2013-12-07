class Mywebroom.Views.ProfileHomeView extends Backbone.View
  className: 'user_profile'

  #*******************
  #**** Templeate
  #*******************

  template: JST['profile/ProfileHomeTemplate']

  #*******************
  #**** Events
  #*******************

  events:
    'click #profile_photos':'showProfilePhotos'
    'click #profile_friends':'showProfileFriends'
    'click #profile_home_basic_info .blueLink':'showProfileFriends'
    'click #profile_key_requests':'showProfileKeyRequests'
    'click #profile_activity':'showProfileActivity'
    'click #profile_objects':'showProfileObjects'
    'click #profile_bookmarks':'showProfileBookmarks'
    'click #profile_home':'showHomeGrid'
    'click #profile_close_button':'closeProfileView'
    'click #Profile-Collapse-Button':'collapseProfileView'
    'click #profile_facebook_friends_invite':'inviteFriendsFacebook'
    #'click .profile_suggestion_name':'showUserProfile'

  #*******************
  #**** Initialize
  #*******************

  initialize: ->
    #Get RoomFlag
    this.model.set 'FLAG_PROFILE', Mywebroom.State.get("roomState")

    #initial limit and offset for apis
    @fetchLimit = 24
    @fetchOffset= 0

    if Mywebroom.State.get("roomState") != "SELF"
      @template=JST['profile/FriendHomeTemplate']

      #Bookmarks and Items Design will be different for Home and Activity
      # new Mywebroom.Collections.IndexUserBookmarksByUserIdAndItemIdByLimitAndOffset(
      #   userId: Mywebroom.State.get('roomData').get('user').id
      #   )
      activityBookmarksRandomCollection = new Mywebroom.Collections.IndexUserBookmarksByUserIdByLimitAndOffset()
      activityBookmarksRandomCollection.fetch
        reset:true
        async:false
        url:activityBookmarksRandomCollection.url Mywebroom.State.get('roomData').get('user').id, @fetchLimit, @fetchOffset
        success: (response)->
          #console.log("activityBookmarksCollection Fetched Successfully Response:")
          #console.log(response)

      activityItemsDesignsRandomCollection = new Mywebroom.Collections.IndexUserItemsDesignsByUserIdByLimitAndOffset()
      activityItemsDesignsRandomCollection.fetch
        reset:true
        async:false
        url:activityItemsDesignsRandomCollection.url Mywebroom.State.get('roomData').get('user').id, @fetchLimit, @fetchOffset
        success: (response)->
          #console.log("Friend's Items Page Fetched Successfully Response:")
          #console.log(response)
    else

      activityBookmarksRandomCollection = new Mywebroom.Collections.IndexRandomBookmarksByLimitByOffsetCollection()
      activityItemsDesignsRandomCollection = new Mywebroom.Collections.IndexRandomItemsByLimitByOffsetCollection()

      #Fetch them
      activityBookmarksRandomCollection.fetch
        url:activityBookmarksRandomCollection.url @fetchLimit, @fetchOffset
        reset:true
        async:false
        success: (response)->
          #console.log("activityBookmarksRandomCollection Fetched Successfully Response:")
          #console.log(response)

      activityItemsDesignsRandomCollection.fetch
        url:activityItemsDesignsRandomCollection.url @fetchLimit, @fetchOffset
        reset:true
        async:false
        success: (response)->
          #console.log("activityItemsDesignsRandomCollection Fetched Successfully Response:")
          #console.log(response)

    @collapseFlag = true

    #Scramble Activity Collection.
    @scrambleItemsAndBookmarks(activityItemsDesignsRandomCollection,activityBookmarksRandomCollection)

    #Calculate Age
    @model.set('age',@getAge(@model.get('birthday')))

  #*******************
  #**** Render - sets up initial structure and layout of the view
  #*******************

  render: ->
    #Get sprite url to send to template:
    spriteUrl = Mywebroom.State.get('staticContent').findWhere('name':'social-tab-icons').get('image_name').url

    #Template shows structure of the view
    $(@el).html(@template(user_info:@model,spriteUrl:spriteUrl))     #pass variables into template.

    #Show the user content
    @showHomeGrid()
    this

  #--------------------------
  # showHomeGrid - Show the content portion of the view
  #--------------------------

  showHomeGrid: ->

    @profileHomeTopView = new Mywebroom.Views.ProfileHomeTopView({model:@model})
    $('#profileHome_top').html(@profileHomeTopView.render().el)
    $('#profileHome_bottom').css "height","450px"
    #Bandaid- make header another table.
    #tableHeader = JST['profile/ProfileGridTableHeader']
    #$("#profileHome_bottom").html(tableHeader())
    $('#profileHome_bottom').html(@ProfileHomeActivityView.el)
    @ProfileHomeActivityView.render()

    $('.profile_menu_selected').removeClass('profile_menu_selected')
    $('#profile_home').addClass('profile_menu_selected')



  ###
  #paginateActivity - handles pagination
  #       -called from $('#gridItemList') scroll event in showActivity
  #       -Function only intended for SELF state
  ###
  paginateActivity:(event) ->
    event.preventDefault()
    event.stopPropagation()

    #Turn event off then on again if needed so each scroll event doesn't trigger another fetch.
    @$('#gridItemList').off('scroll')


    #1a. Increment Offset
    event.data.fetchOffset += event.data.fetchLimit;

    #1. Grab more Designs
    #2. Grab more Bookmarks
    activityBookmarksRandomCollection = new Mywebroom.Collections.IndexRandomBookmarksByLimitByOffsetCollection()
    activityItemsDesignsRandomCollection = new Mywebroom.Collections.IndexRandomItemsByLimitByOffsetCollection()

    #3. Fetch them
    activityBookmarksRandomCollection.fetch
      url:activityBookmarksRandomCollection.url event.data.fetchLimit, event.data.fetchOffset
      reset:true
      async:false

    activityItemsDesignsRandomCollection.fetch
      url:activityItemsDesignsRandomCollection.url event.data.fetchLimit, event.data.fetchOffset
      reset:true
      async:false

    #4. Shuffle them
    tempCollection = new Backbone.Collection()
    tempCollection.add(activityItemsDesignsRandomCollection.toJSON(),{silent:true})
    tempCollection.add(activityBookmarksRandomCollection.toJSON(),{silent:true})
    tempCollection.reset(tempCollection.shuffle(),{silent:true})


    #5. Add them to the collection. (Marionette takes care of render)
    event.data.activityCollection.add(tempCollection.toJSON())

    #6. If nothing fetched, turn off the scroll event.
    if activityItemsDesignsRandomCollection.models.length < event.data.fetchLimit or activityBookmarksRandomCollection < event.data.fetchLimit
      @$('#gridItemList').off('scroll')
    else
      that = this
      @$('#gridItemList').off('scroll').on('scroll',that,(event)->
        if $(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight-100
          event.data.paginateActivity(event)
      )

  ###
  #paginateFriendActivity - handles pagination of Friend's Activity Page
  #       -called from $('#gridItemList') scroll event in showActivity
  #       -Function only intended for FRIEND state
  ###
  paginateFriendActivity:(event) ->
    event.preventDefault()
    event.stopPropagation()

    #Turn event off then on again if needed so each scroll event doesn't trigger another fetch.
    @$('#gridItemList').off('scroll')

    #1a. Increment Offset
    event.data.fetchOffset += event.data.fetchLimit;

    #1. Grab more Designs
    #2. Grab more Bookmarks
    activityFriendBookmarksCollection = new Mywebroom.Collections.IndexUserBookmarksByUserIdByLimitAndOffset()
    activityFriendItemsDesignsCollection = new Mywebroom.Collections.IndexUserItemsDesignsByUserIdByLimitAndOffset()

    #3. Fetch them
    activityFriendBookmarksCollection.fetch
      url:activityFriendBookmarksCollection.url @model.get('user_id'), event.data.fetchLimit, event.data.fetchOffset
      reset:true
      async:false

    activityFriendItemsDesignsCollection.fetch
      url:activityFriendItemsDesignsCollection.url @model.get('user_id'), event.data.fetchLimit, event.data.fetchOffset
      reset:true
      async:false

    #4. Shuffle them
    tempCollection = new Backbone.Collection()
    tempCollection.add(activityFriendItemsDesignsCollection.toJSON(),{silent:true})
    tempCollection.add(activityFriendBookmarksCollection.toJSON(),{silent:true})
    tempCollection.reset(tempCollection.shuffle(),{silent:true})


    #5. Add them to the collection. (Marionette takes care of render)
    event.data.activityCollection.add(tempCollection.toJSON())

    #6. If nothing fetched, turn off the scroll event.
    if activityFriendItemsDesignsCollection.models.length < event.data.fetchLimit and activityFriendBookmarksCollection.models.length < event.data.fetchLimit
      @$('#gridItemList').off('scroll')
    else
      that = this
      @$('#gridItemList').off('scroll').on('scroll',that,(event)->
        if $(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight-100
          event.data.paginateFriendActivity(event)
      )


  #*******************
  #**** Functions  Initialize Profile Welcome View
  #*******************

  #--------------------------
  # scramble activity and initialize activity view
  #--------------------------
  scrambleItemsAndBookmarks:(ItemsDesignsCollection, BookmarksRandomCollection) ->
    #For initial collection
    @activityCollection = new Backbone.Collection()
    @activityCollection.add(ItemsDesignsCollection.toJSON(), {silent:true})
    @activityCollection.add(BookmarksRandomCollection.toJSON(),{silent:true})
    @activityCollection.reset(@activityCollection.shuffle(),{silent:true})
    initialProfileHomeActivityCollection = new Backbone.Collection
    initialProfileHomeActivityCollection.set(@activityCollection.first 6)
    if Mywebroom.State.get("roomState") is "PUBLIC"
      @activityCollection.reset(@activityCollection.first(9),{silent:true})
    if Mywebroom.State.get("roomState") != "SELF" and Mywebroom.State.get('roomData').get('user_profile').firstname
      headerName = Mywebroom.State.get('roomData').get('user_profile').firstname + "'s things"
    else
      headerName = 'Latest Room Additions'

    @ProfileHomeActivityView = new Mywebroom.Views.ProfileActivityView2({collection:initialProfileHomeActivityCollection, headerName:headerName})

  #*******************
  #**** Functions  Event functions to alter views
  #*******************

  showProfilePhotos: ->
    $('.profile_menu_selected').removeClass('profile_menu_selected')
    $('#profile_photos').addClass('profile_menu_selected')

    @photosView = new Mywebroom.Views.ProfilePhotosView(model: @model)
    @profileHomeTopView.remove()
    $('#profileHome_top').css "height","auto"
    $('#profileHome_top').html ""
    $('#profileHome_bottom').css "height","550px"
    $('#profileHome_bottom').html(@photosView.render().el)
    if Mywebroom.State.get("roomState") != "SELF"
      $('#profile_upload_photos_button').remove()





  # Responsible for Key Requests View, Key Requests Single View and Suggested Friends View and Suggested Friends Single View
  showProfileKeyRequests: ->

    $('.profile_menu_selected').removeClass('profile_menu_selected')
    $('#profile_key_requests').addClass('profile_menu_selected')

    # /*Note on key request view, we do not want profile-bottom overflow on. */
    topTemplate= JST['profile/ProfileSmallTopTemplate']
    optionalButton = "<img src='http://res.cloudinary.com/hpdnx5ayv/image/upload/v1379965946/invite-friends-with-facebook.png'>"

    $('#profileHome_top').css "height","auto"
    $('#profileHome_top').html ""

    $('#profileHome_top').html(topTemplate(user_info:@model,optionalButton:optionalButton))
    @keyRequestsView = new Mywebroom.Views.ProfileKeyRequestsView(model:@model)
    $('#profileHome_bottom').html(@keyRequestsView.el)
    @keyRequestsView.render()


  showProfileFriends: ->

    $('.profile_menu_selected').removeClass('profile_menu_selected')
    $('#profile_friends').addClass('profile_menu_selected')

    topTemplate = JST['profile/ProfileSmallTopTemplate']

    $('#profileHome_top').css "height","auto"
    $('#profileHome_top').html ""

    $('#profileHome_top').html(topTemplate(user_info:@model,optionalButton:"Invite Friends With FB!"))


    @friendsView = new Mywebroom.Views.ProfileFriendsView(model:@model)
    $('#profileHome_bottom').html(@friendsView.render().el)




  showProfileActivity:->

    $('.profile_menu_selected').removeClass('profile_menu_selected')
    $('#profile_activity').addClass('profile_menu_selected')

    #send full collection to this view.
    if Mywebroom.State.get("roomState") is "SELF"
      headerName = "Activity"
    else
      if Mywebroom.State.get('roomData').get('user_profile').firstname
        headerName = Mywebroom.State.get('roomData').get('user_profile').firstname + "'s things"
      else
        headerName = Mywebroom.State.get('roomData').get('user').username + "'s things"

    @profileActivityView = new Mywebroom.Views.ProfileActivityView2({collection:@activityCollection,headerName:headerName,model:@model,className:"profileActivity_activity generalGrid"})

    # Modify Top Portion
    $('#profileHome_top').css "height","70px"
    $('#profileHome_bottom').css "height","550px"
    topTemplate = JST['profile/ProfileSmallTopTemplate']
    $('#profileHome_top').html(topTemplate(user_info:@model,optionalButton:""))
    #$('#profileHome_bottom').html(JST['profile/ProfileGridTableHeader'](headerName:"Activity"))
    $('#profileHome_bottom').html(@profileActivityView.el)
    @profileActivityView.render()
    #if room is Self, allow endless activity scrolling.

    #set Paginate Activity event -
    that = this
    if Mywebroom.State.get("roomState") is "SELF"
      @$('#gridItemList').off('scroll').on('scroll',that,(event)->
        if $(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight-100
          event.data.paginateActivity(event)
      )
    else if Mywebroom.State.get("roomState") is "FRIEND"
      @$('#gridItemList').off('scroll').on('scroll',that,(event)->
        if $(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight-100
          event.data.paginateFriendActivity(event)
      )




  #--------------------------
  # showProfileBookmarks - Only shows on Friend/Public Profile View
  #--------------------------
  showProfileBookmarks:->

    $('.profile_menu_selected').removeClass('profile_menu_selected')
    $('#profile_bookmarks').addClass('profile_menu_selected')

    # show user Bookmarks
    @profileBookmarksView = new Mywebroom.Views.ProfileBookmarksView({model:@model})
    $('#profileHome_top').html('')
    $('#profileHome_top').css 'height', 'auto'
    $("#profileHome_bottom").html(@profileBookmarksView.el)
    @profileBookmarksView.render()




  #--------------------------
  # showProfileObjects - Only shows on Friend/Public Profile View
  #--------------------------
  showProfileObjects:->

    $('.profile_menu_selected').removeClass('profile_menu_selected')
    $('#profile_objects').addClass('profile_menu_selected')

    # Show user Objects
    profileObjectsCollection = new Backbone.Collection()
    profileObjectsCollection.set(@model.get('user_items_designs'))
    profileObjectsCollection.reset(profileObjectsCollection.shuffle(),{silent:true})
    @profileObjectsView = new Mywebroom.Views.ProfileObjectsView({collection:profileObjectsCollection,model:@model})
    $('#profileHome_top').html('')
    $('#profileHome_top').css 'height', 'auto'
    $("#profileHome_bottom").html(@profileObjectsView.el)
    @profileObjectsView.render()




  #*******************
  #**** Functions  View layout
  #*******************
  collapseProfileView: ->

    #If Large View is open, close LargeView. Otherwise, proceed.
 	  if Mywebroom.State.get('profileLargeView')
      Mywebroom.State.get('profileLargeView').closeView()
    else
      # If view is open, close it, else reverse.
   	  # Change profile_home_container width to 0
   	  # Change profileHome_container left o 720px
      # BUG: Click collapse error while Large Photo View is on
      if @collapseFlag is false
        $("#profileHome_container").css "left", "0px"
        $('#profile_home_container').css "width", "720px"
        setTimeout (->
          $('#profile_drawer').css "width","760px"
          $('#profile_collapse_arrow img').removeClass('flipimg')
          ),500
        #$('#profile_drawer').css "width","760px"
        @collapseFlag = true

        #@collapseFlag=true
      else
        $("#profileHome_container").css "left", "-2720px"
        $('#profile_drawer').css "width","130px"#sidebarWidth + drawerWidth
        #Collapse Icon turn around.
        $('#profile_collapse_arrow img').addClass('flipimg')
        #To enable hover on objects again set timeout on width
        setTimeout (->
          $("#profile_home_container").css "width", "0px"), 1000
        @collapseFlag = false




  # Calculates and return age. Argument is string YYYY-MM-DD
  getAge: (birthday) ->
    if birthday is undefined || birthday is null || birthday is ''
      return


    now = new Date()

    dob = birthday.split '-'


    if dob.length is 3
      born = new Date(parseInt(dob[0]), parseInt(dob[1]) - 1, parseInt(dob[2]))
      age = now.getFullYear() - (born.getFullYear())
      if now.getMonth() < born.getMonth()
        age--
      if now.getMonth() is born.getMonth()
        if now.getDate() < born.getDate()
          age -= 1
          age
      else
        return age
    else
      return ''





  # Create a Facebook Requests Dialog to invite Facebook Friends
  inviteFriendsFacebook: ->


    signInState = Mywebroom.State.get("signInState")
    if signInState is true

      firstname = Mywebroom.State.get("signInData").get("user_profile").firstname
      lastname = Mywebroom.State.get("signInData").get("user_profile").lastname
      username =  Mywebroom.State.get("signInUser").get("username")

      if firstname and lastname
        requestMessage = "Your friend " + firstname + " " + lastname + " would like to invite you to join myWebRoom.com, a visual way to organize your online life. Create a virtual room, add your favorite products, access all your sites, and check out your friend's room!"
      else if username
        requestMessage = "Your friend " + username + " would like to invite you to join myWebRoom.com, a visual way to organize your online life. Create a virtual room, add your favorite products, access all your sites, and check out your friend's room!"
      else
        requestMessage = "Your friend would like to invite you to join myWebRoom.com, a visual way to organize your online life. Create a virtual room, add your favorite products, access all your sites, and check out your friend's room!"


    else
      requestMessage = "Your friend would like to invite you to join myWebRoom.com, a visual way to organize your online life. Create a virtual room, add your favorite products, access all your sites, and check out your friend's room!"
    FB.ui
      method: "apprequests"
      message: requestMessage
    , (request) ->
      #console.log 'inviteFriendsFacebook ui call: '
      #console.log request



  closeProfileView: ->
    $('#xroom_profile').hide()
    #turn on events
    #Turn on events:

    #1. Image Hover: on or off
    if Object.keys(Mywebroom.Data.ItemModels).length then Mywebroom.Helpers.turnOnHover()


    #2. Image Click: on or off
    Mywebroom.Helpers.turnOnDesignClick()

    #3. Scroller visibility
    $("#xroom_scroll_left").show()
    $("#xroom_scroll_right").show()
