class Mywebroom.Views.ProfileHomeView extends Backbone.View
 className: 'user_profile'
 template: JST['profile/profileHome']
 #We should eventually make profileBottom its own view to remove and re-render. 
 #There may be memory leaks with this method
 events:
 	'click #profile_photos':'showProfilePhotos',
 	'click #profile_friends':'showProfileFriends',
  'click #profile_home_basic_info .blueLink':'showProfileFriends',
 	'click #profile_key_requests':'showProfileKeyRequests',
 	'click #profile_home':'showHomeGrid',
 	'click #Profile-Close-Button':'closeProfileView'
 	'click #Profile-Collapse-Button':'collapseProfileView'
  # 'click .gridItem':'getGridItemModel'
  # 'mouseenter .gridItem':'showSocialBarView' #should this be in gridView?
  # 'mouseleave .gridItem':'closeSocialBarView'
 initialize: ->
  @activityCollection = new Mywebroom.Collections.index_notification_by_limit_by_offset()
  @friendsCollection = new Mywebroom.Collections.Index_Friend_By_User_Id_By_Limit_By_Offset()
  @keyRequestsCollection = new Mywebroom.Collections.Index_Friend_Request_Make_From_Your_Friend_To_You_By_User_Id()

  #initial limit and offset for apis
  @initialLimit = 6
  @initialOffset= 0

  @activityCollection.fetch
    url:@activityCollection.url @initialLimit, @initialOffset
    reset:true
    async:false
    success: (response)->
      console.log("ActivityCollection Fetched Successfully Response:")
      console.log(response)
  
  
  #Fetch friends data for Profile Friends
  @friendsCollection.fetch
    url:@friendsCollection.url @model.get('user_id'), @initialLimit, @initialOffset
    async:false
    success: (response)->
     console.log("FriendsCollection Fetched Successfully")
     console.log(response)
  #Fetch friends data for Profile Friends
  @keyRequestsCollection.fetch
    url: @keyRequestsCollection.url @model.get('user_id')
    async:false
    success: (response)->
     console.log("KeyRequestsCollection Fetched Successfully")
     console.log(response)

  @profileHomeTopView = new Mywebroom.Views.ProfileHomeTopView({model:@model})
 	
 	@activityView = new Mywebroom.Views.ProfileActivityView({collection:@activityCollection})
 	if @friendsCollection
 		@friendsView = new Mywebroom.Views.ProfileFriendsView({collection:@friendsCollection})
 	if @keyRequestsCollection
 		@keyRequestsView = new Mywebroom.Views.ProfileKeyRequestsView({collection:@keyRequestsCollection})

 	#Try initialize Friend Suggestions here
 	@friendsSuggestionsCollection = new Mywebroom.Collections.IndexFriendsSuggestionsByUserIdByOffsetByLimit()
 	#user_id = @model.get('user_id')
 	user_id= this.model.get('user_id')
 	limit = 10;
 	offset = 0;
 	#Fetch suggestion data for Profile Friends Requests
 	#Getting error in backbone once fetch is done and model start populating.
 	@friendsSuggestionsCollection.fetch
      url:'/friends/json/index_friends_suggestion_by_user_id_by_limit_by_offset/'+user_id+'/'+limit+'/'+offset+'.json'
      reset:true
      async:false
      success: (response)->
       console.log("friendsSuggestionsCollection Fetched Successfully")
       console.log(response)
  @friendsSuggestionsView = new Mywebroom.Views.ProfileFriendsSuggestionSingleView({collection:@friendsSuggestionsCollection})
 	#@activityCollection.on('reset', @render, this)
   #@collection.on('reset',@render,this)

 render: ->
   $(@el).html(@template(user_info:@model))     #pass variables into template.
   #attach top portion of view
   $("#profileHome_top").append(@profileHomeTopView.el)
   @profileHomeTopView.render()
   #Set min height for #profile_home_container based on browser size
   $('#profileHome_container').css "min-height",'656px'
   #Display User Activity
   @showHomeGrid()
   this
 showProfilePhotos: ->
  @photosView = new Mywebroom.Views.ProfilePhotosView(model:@model) 
  @profileHomeTopView.remove()
  $('#profileHome_top').css "height","70px"
  #CONCERN: OptionalButton will be tied to events eventually. Need to refactor to make easy to maintain
  topTemplate= JST['profile/ProfileSmallTopViewTemplate']
  $('#profileHome_top').html(topTemplate(user_info:@model,optionalButton:"Upload Photos"))
 	$('#profileHome_bottom').html(@photosView.render().el)
 #Responsible for Key Requests View, Key Requests Single View and Suggested Friends View and Suggested Friends Single View 
 showProfileKeyRequests: ->
 	if @keyRequestsView

 		$('#profileHome_bottom').html(@keyRequestsView.el) 	
 		@keyRequestsView.render()
 		@keyRequestsCollection.forEach(@keyRequestAddView,this)
 		@showSuggestedFriends()
 		
 keyRequestAddView: (keyRequest) ->
 	keyRequestSingleView = new Mywebroom.Views.ProfileKeyRequestSingleView({model:keyRequest})
 	$('#profile_key_request_list').append(keyRequestSingleView.$el)
 	keyRequestSingleView.render()
 	console.log(@keyRequestsView.el)
 showSuggestedFriends: ->
 	if @friendsSuggestionsView
 		@friendsSuggestionsCollection.forEach(@friendsSuggestionAddView, this)
 	
 friendsSuggestionAddView: (friendSuggestion) ->
 	friendSuggestionSingleView = new Mywebroom.Views.ProfileFriendsSuggestionSingleView({model:friendSuggestion})
 	$('#profile_suggested_friends_list').append(friendSuggestionSingleView.$el)
 	friendSuggestionSingleView.render()

 showProfileFriends: ->
 	if @friendsView
 		#Need to get a collection view, then a subview for each model.
 		#Feed each model profileFriends View
 		$('#profileHome_bottom').html("<h1>Friends View y'all<h1>")
 		@friendsCollection.forEach(@friendsAddView,this)
 	#initalize new Profile Friends model. 
 friendsAddView: (friend) ->
 	friendView = new Mywebroom.Views.ProfileFriendsView({model:friend})
 	$('#profileHome_bottom').append(friendView.el)
 	friendView.render()
 showHomeGrid: ->
 	$('#profileHome_top').html(@profileHomeTopView.render().el)
 	$('#profileHome_bottom').html(@activityView.el)
 	@activityView.render()
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