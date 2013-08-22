class Mywebroom.Views.ProfileHomeView extends Backbone.View
 className: 'user_profile'
 template: JST['profile/ProfileHomeTemplate']
 #We should eventually make profileBottom its own view to remove and re-render. 
 #There may be memory leaks with this method
 events:
 	'click #profile_photos':'showProfilePhotos',
 	'click #profile_friends':'showProfileFriends',
  'click #profile_home_basic_info .blueLink':'showProfileFriends',
 	'click #profile_key_requests':'showProfileKeyRequests',
  'click #profile_activity':'showProfileActivity',
 	'click #profile_home':'showHomeGrid',
 	'click #Profile-Close-Button':'closeProfileView'
 	'click #Profile-Collapse-Button':'collapseProfileView'

 initialize: ->
  @profileHomeTopView = new Mywebroom.Views.ProfileHomeTopView({model:@model})
  @activityCollection = new Mywebroom.Collections.IndexNotificationByLimitByOffsetCollection()
  #initial limit and offset for apis
  @initialLimit = 24
  @initialOffset= 0
  @activityCollection.fetch
    url:@activityCollection.url @initialLimit, @initialOffset
    reset:true
    async:false
    success: (response)->
      console.log("ActivityCollection Fetched Successfully Response:")
      console.log(response)
  #For ProfileHomeActivity screen, only send the first 6
  tempProfileHomeActivityCollection = new Backbone.Collection
  tempProfileHomeActivityCollection.set(@activityCollection.first 6)
 	@ProfileHomeActivityView = new Mywebroom.Views.ProfileActivityView({collection:tempProfileHomeActivityCollection})

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
 showProfilePhotos: ->
  @photosView = new Mywebroom.Views.ProfilePhotosView(model:@model) 
  @profileHomeTopView.remove()
  $('#profileHome_top').css "height","70px"
  $('#profileHome_bottom').css "height","550px"
  #CONCERN: OptionalButton will be tied to events eventually. Need to refactor to make easy to maintain
  topTemplate= JST['profile/ProfileSmallTopTemplate']
  $('#profileHome_top').html(topTemplate(user_info:@model,optionalButton:"Upload Photos"))
 	$('#profileHome_bottom').html(@photosView.render().el)
 #Responsible for Key Requests View, Key Requests Single View and Suggested Friends View and Suggested Friends Single View 
 showProfileKeyRequests: ->
  @keyRequestsView = new Mywebroom.Views.ProfileKeyRequestsView(model:@model)
  $('#profileHome_bottom').html(@keyRequestsView.el) 	
  @keyRequestsView.render()

 showProfileFriends: ->
  @friendsView = new Mywebroom.Views.ProfileFriendsView(model:@model)
  $('#profileHome_bottom').html(@friendsView.render().el)

 showProfileActivity:->
  #send full collection to this view.
  @profileActivityView = new Mywebroom.Views.ProfileActivityView({collection:@activityCollection})
  #Modify Top Portion
  $('#profileHome_top').css "height","70px"
  $('#profileHome_bottom').css "height","550px"
  topTemplate= JST['profile/ProfileSmallTopTemplate']
  $('#profileHome_top').html(topTemplate(user_info:@model,optionalButton:""))
  $('#profileHome_bottom').html(@profileActivityView.el)
  @profileActivityView.render()

 showHomeGrid: ->
 	$('#profileHome_top').html(@profileHomeTopView.render().el)
  $('#profileHome_bottom').css "height","400px"
 	$('#profileHome_bottom').html(@ProfileHomeActivityView.el)
 	@ProfileHomeActivityView.render()

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
    	console.log "CollapseProfileView"
  		else
    		$("#profileHome_container").css "left", "-720px"
    		$('#profile_drawer').css "width","130px"#sidebarWidth + drawerWidth
    		#Collapse Icon turn around.
    		$('#profile_collapse_arrow img').addClass('flipimg')
    		#To enable hover on objects again set timeout on width
    		setTimeout (->
    			$("#profile_home_container").css "width", "0px"), 2000
    		console.log "UN-CollapseProfileView"

 closeProfileView: ->
 	this.remove()