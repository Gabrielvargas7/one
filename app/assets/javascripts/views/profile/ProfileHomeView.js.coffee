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
 	'click #profile_photos':'showProfilePhotos',
 	'click #profile_friends':'showProfileFriends',
  'click #profile_home_basic_info .blueLink':'showProfileFriends',
 	'click #profile_key_requests':'showProfileKeyRequests',
  'click #profile_activity':'showProfileActivity',
  'click #profile_objects':'showProfileObjects',
  'click #profile_bookmarks':'showProfileBookmarks',
 	'click #profile_home':'showHomeGrid',
 	'click #Profile-Close-Button':'closeProfileView',
 	'click #Profile-Collapse-Button':'collapseProfileView'
  #'click .profile_suggestion_name':'showUserProfile'

  #*******************
  #**** Initialize
  #*******************

 initialize: ->
  #Get RoomFlag
  this.model.set 'FLAG_PROFILE', this.options.FLAG_PROFILE
  if this.options.FLAG_PROFILE != Mywebroom.Views.RoomView.MY_ROOM
    @template=JST['profile/FriendHomeTemplate']
  @collapseFlag = false
  
  #initial limit and offset for apis
  initialLimit = 24
  initialOffset= 0

  activityBookmarksRandomCollection = new Mywebroom.Collections.IndexRandomBookmarksByLimitByOffsetCollection()
  activityItemsDesignsRandomCollection = new Mywebroom.Collections.IndexRandomItemsByLimitByOffsetCollection()
  #Fetch them
  activityBookmarksRandomCollection.fetch
    url:activityBookmarksRandomCollection.url initialLimit, initialOffset
    reset:true
    async:false
    success: (response)->
      console.log("activityBookmarksRandomCollection Fetched Successfully Response:")
      console.log(response)
  activityItemsDesignsRandomCollection.fetch
    url:activityItemsDesignsRandomCollection.url initialLimit, initialOffset
    reset:true
    async:false
    success: (response)->
      console.log("activityItemsDesignsRandomCollection Fetched Successfully Response:")
      console.log(response)
  #Scramble Activity Collection.
  @scrambleItemsAndBookmarks(activityItemsDesignsRandomCollection,activityBookmarksRandomCollection)


  #*******************
  #**** Render - sets up initial structure and layout of the view
  #*******************
 
 render: ->
    #Template shows structure of the view. 
   $(@el).html(@template(user_info:@model))     #pass variables into template.
   $('#profileHome_container').css "min-height",'720px'
   #Show the user content 
   @showHomeGrid()
   this

  #--------------------------
  # showHomeGrid - Show the content portion of the view
  #--------------------------

 showHomeGrid: ->

  @profileHomeTopView = new Mywebroom.Views.ProfileHomeTopView({model:@model})
  $('#profileHome_top').html(@profileHomeTopView.render().el)
  #$('#profileHome_bottom').css "height","450px"
  #Bandaid- make header another table.
  tableHeader = JST['profile/ProfileGridTableHeader']
  $("#profileHome_bottom").html(tableHeader(headerName:'Latest Room Additions'))
  $('#profileHome_bottom').append(@ProfileHomeActivityView.el)
  @ProfileHomeActivityView.render()

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
  @ProfileHomeActivityView = new Mywebroom.Views.ProfileActivityView({collection:initialProfileHomeActivityCollection})

  #*******************
  #**** Functions  Event functions to alter views
  #*******************

 showProfilePhotos: ->
  @photosView = new Mywebroom.Views.ProfilePhotosView(model:@model) 
  @profileHomeTopView.remove()
  $('#profileHome_top').css "height","auto"
  $('#profileHome_top').html ""
  $('#profileHome_bottom').css "height","550px"
 	$('#profileHome_bottom').html(@photosView.render().el)
 
 #Responsible for Key Requests View, Key Requests Single View and Suggested Friends View and Suggested Friends Single View 
 showProfileKeyRequests: ->
  # /*Note on key request view, we do not want profile-bottom overflow on. */
  topTemplate= JST['profile/ProfileSmallTopTemplate']
  optionalButton = "<img src='http://res.cloudinary.com/hpdnx5ayv/image/upload/v1379965946/invite-friends-with-facebook.png'>"
  $('#profileHome_top').html(topTemplate(user_info:@model,optionalButton:optionalButton))
  @keyRequestsView = new Mywebroom.Views.ProfileKeyRequestsView(model:@model)
  $('#profileHome_bottom').html(@keyRequestsView.el) 	
  @keyRequestsView.render()

 showProfileFriends: ->
  topTemplate= JST['profile/ProfileSmallTopTemplate']
  $('#profileHome_top').html(topTemplate(user_info:@model,optionalButton:"Invite Friends With FB!"))
  @friendsView = new Mywebroom.Views.ProfileFriendsView(model:@model)
  $('#profileHome_bottom').html(@friendsView.render().el)

 showProfileActivity:->
  #send full collection to this view.
  @profileActivityView = new Mywebroom.Views.ProfileTableOuterDivView({collection:@activityCollection})
  #Modify Top Portion
  $('#profileHome_top').css "height","70px"
  $('#profileHome_bottom').css "height","550px"
  topTemplate= JST['profile/ProfileSmallTopTemplate']
  $('#profileHome_top').html(topTemplate(user_info:@model,optionalButton:""))
  $('#profileHome_bottom').html(JST['profile/ProfileGridTableHeader'](headerName:"Activity"))
  $('#profileHome_bottom').append(@profileActivityView.el)
  @profileActivityView.render()

  #--------------------------
  # showProfileBookmarks - Only shows on Friend/Public Profile View
  #--------------------------
 showProfileBookmarks:->
  #show user Bookmarks
  @profileBookmarksView = new Mywebroom.Views.ProfileBookmarksView({model:@model})
  $('#profileHome_top').html('')
  $('#profileHome_top').css 'height', 'auto'
  $("#profileHome_bottom").html(@profileBookmarksView.el)
  @profileBookmarksView.render()

  
  #--------------------------
  # showProfileObjects - Only shows on Friend/Public Profile View
  #--------------------------
 showProfileObjects:->
  #Show user Objects
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
 	#If view is open, close it, else reverse.
 	#Change profile_home_container width to 0
 	#Change profileHome_container left o 720px
  #BUG: Click collapse error while Large Photo View is on
 	if @collapseFlag is false
    $("#profileHome_container").css "left", "0px"
    $('#profile_home_container').css "width", "720px"
    $('#profile_drawer').css "width","760px"
    @collapseFlag=true
    $('#profile_collapse_arrow img').removeClass('flipimg')
    #@collapseFlag=true
  	else
    $("#profileHome_container").css "left", "-720px"
    $('#profile_drawer').css "width","130px"#sidebarWidth + drawerWidth
    #Collapse Icon turn around.
    $('#profile_collapse_arrow img').addClass('flipimg')
    #To enable hover on objects again set timeout on width
    setTimeout (->
    	$("#profile_home_container").css "width", "0px"), 1000
    @collapseFlag = false

 closeProfileView: ->
# 	this.remove()
#  Mywebroom.vent.trigger("destroy:profile")
#  this.options.roomHeaderView.delegateEvents() # add all header events
   $('#xroom_profile').hide()
