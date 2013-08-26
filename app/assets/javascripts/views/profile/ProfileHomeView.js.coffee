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
  'click .profile_suggestion_name':'showUserProfile'

  #*******************
  #**** Initialize
  #*******************

 initialize: ->
  #Get RoomFlag
  #@TestRoomFlag = 'MY_FRIEND_ROOM'
  if this.options.FLAG_PROFILE is Mywebroom.Views.RoomView.MY_FRIEND_ROOM
    @template=JST['profile/FriendHomeTemplate']
    
  #initial limit and offset for apis
  @initialLimit = 24
  @initialOffset= 0
  #initial Top View for Profile Welcome Screen
  @profileHomeTopView = new Mywebroom.Views.ProfileHomeTopView({model:@model})
  #Activity Collection is a combo of random bookmarks and objects. 
  #Activity Collection is a scramble of both, fetched below.
  @activityCollection = new Backbone.Collection()
  @activityBookmarksRandomCollection = new Mywebroom.Collections.IndexRandomBookmarksByLimitByOffsetCollection()
  @activityItemsDesignsRandomCollection = new Mywebroom.Collections.IndexRandomItemsByLimitByOffsetCollection()
  #Fetch them
  @activityBookmarksRandomCollection.fetch
    url:@activityBookmarksRandomCollection.url @initialLimit, @initialOffset
    reset:true
    async:false
    success: (response)->
      console.log("activityBookmarksRandomCollection Fetched Successfully Response:")
      console.log(response)
  @activityItemsDesignsRandomCollection.fetch
    url:@activityItemsDesignsRandomCollection.url @initialLimit, @initialOffset
    reset:true
    async:false
    success: (response)->
      console.log("activityItemsDesignsRandomCollection Fetched Successfully Response:")
      console.log(response)
  #Scramble Activity Collection.
  @scrambleItemsAndBookmarks()


  #*******************
  #**** Render - sets up initial structure and layout of the view
  #*******************
 
 render: ->
   $(@el).html(@template(user_info:@model))     #pass variables into template.
   #attach top portion of view
   # $("#profileHome_top").append(@profileHomeTopView.el)
   # @profileHomeTopView.render()
   #Set min height for #profile_home_container based on browser size
   $('#profileHome_container').css "min-height",'656px'
   #Display User Activity
   @showHomeGrid()
   this

  #--------------------------
  # showHomeGrid - Show the content portion of the view
  #--------------------------

 showHomeGrid: ->
  $('#profileHome_top').html(@profileHomeTopView.render().el)
  $('#profileHome_bottom').css "height","450px"
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
 scrambleItemsAndBookmarks: ->
  #For initial collection
  @activityCollection.add(@activityItemsDesignsRandomCollection.toJSON(), {silent:true})
  @activityCollection.add(@activityBookmarksRandomCollection.toJSON(),{silent:true})
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
  #CONCERN: OptionalButton will be tied to events eventually. Need to refactor to make easy to maintain
  #topTemplate= JST['profile/ProfileSmallTopTemplate']
  #$('#profileHome_top').html(topTemplate(user_info:@model,optionalButton:"Upload Photos"))
 	$('#profileHome_bottom').html(@photosView.render().el)
 
 #Responsible for Key Requests View, Key Requests Single View and Suggested Friends View and Suggested Friends Single View 
 showProfileKeyRequests: ->
  # /*Note on key request view, we do not want profile-bottom overflow on. */
  topTemplate= JST['profile/ProfileSmallTopTemplate']
  $('#profileHome_top').html(topTemplate(user_info:@model,optionalButton:"Invite Friends With FB!"))
  @keyRequestsView = new Mywebroom.Views.ProfileKeyRequestsView(model:@model)
  $('#profileHome_bottom').html(@keyRequestsView.el) 	
  @keyRequestsView.render()

 showProfileFriends: ->
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

 showProfileBookmarks:->
  #show user Bookmarks

 showProfileObjects:->
  #Show user Objects
  @profileObjectsView = new Mywebroom.Views.ProfileObjectsView({collection:@activityCollection,model:@model})
  $('#profileHome_top').html('')
  $('#profileHome_top').css 'height', 'auto'
  $("#profileHome_bottom").html(@profileObjectsView.el)
  @profileObjectsView.render()
 showUserProfile:->
  @TestRoomFlag = 'MY_FRIEND_ROOM'
  console.log('showUserProfile runs')

  #*******************
  #**** Functions  View layout
  #*******************


 collapseProfileView: ->
 	#If view is open, close it, else reverse.
 	#Sara Note- this is odd looking Coffeescript. I don't see any 
 	#	documentation that elses need to be indented, but that appears to be the case here.
 	#Change profile_home_container width to 0
 	#Change profileHome_container left o 720px
  #BUG: Click collapse error while Large Photo View is on
 	if $("#profileHome_container").css("left") is "-720px"
    	$("#profileHome_container").css "left", "0px"
    	$('#profile_home_container').css "width", "720px"
    	$('#profile_drawer').css "width","760px"
    	$('#profile_collapse_arrow img').removeClass('flipimg')
  		else
    		$("#profileHome_container").css "left", "-720px"
    		$('#profile_drawer').css "width","130px"#sidebarWidth + drawerWidth
    		#Collapse Icon turn around.
    		$('#profile_collapse_arrow img').addClass('flipimg')
    		#To enable hover on objects again set timeout on width
    		setTimeout (->
    			$("#profile_home_container").css "width", "0px"), 2000

 closeProfileView: ->
 	this.remove()
  this.options.roomHeaderView.delegateEvents() # add all header events
