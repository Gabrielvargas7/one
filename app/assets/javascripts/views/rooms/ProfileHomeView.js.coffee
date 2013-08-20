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
 	@activityCollection=@options.activityCollection
 	@photosCollection=@options.photosCollection
 	@friendsCollection=@options.friendsCollection
 	@keyRequestsCollection=@options.keyRequestsCollection

 	@photosView = new Mywebroom.Views.ProfilePhotosView({collection:@photosCollection})
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
      reset:true;
      success: (response)->
       console.log("friendsSuggestionsCollection Fetched Successfully")
       console.log(response)
    @friendsSuggestionsView = new Mywebroom.Views.ProfileFriendsSuggestionSingleView({collection:@friendsSuggestionsCollection})
 	#@activityCollection.on('reset', @render, this)
   #@collection.on('reset',@render,this)

 render: ->
   #attribute = this.model.toJSON()
   #console.log("ProfileHomeView model toJSON: "+attribute)
   $(@el).html(@template(user_info:@model))     #pass variables into template.
   #Set min height for #profile_home_container based on browser size
   $('#profileHome_container').css "min-height",'656px'
   #Display User Activity
   @showHomeGrid()
   this
 showProfilePhotos: ->
 	#initialize new Profile Photos view
  $('#profileHome_top').html("<h1>New ProfileHome Top</h1>")
  $('#profileHome_top').css "height","70px"
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
 	console.log("One day I'll show friend suggestions!")
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
 	console.log("ShowHomeGrid runs")
 	#homeGridtemplate= JST['profile/profileHomeGrid']
 	$('#profileHome_bottom').html(@activityView.el)
 	@activityView.render()
 collapseProfileView: ->
 	#If view is open, close it, else reverse.
 	#Sara Note- this is odd looking Coffeescript. I don't see any 
 	#	documentation that elses need to be indented, but that appears to be the case here.
 	#Change profile_home_container width to 0
 	#Change profileHome_container left o 720px
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
 # getGridItemModel: (event) ->
 #  event.stopPropagation()
 #  dataID = event.currentTarget.dataset.id
 #  console.log("You clicked a grid Item " +dataID)
 #  #gridItem is either Activity Item or Photo. Determine which. 
 #  currentGridItem = @activityCollection.get(dataID)
 #  if !currentGridItem
 #    if @photosCollection
 #      currentGridItem = @photosCollection.get(dataID)
 #      if currentGridItem
 #        #launch new view. profile_drawer needs to expand
 #        $("#profile_drawer").css "width", "1320px"
 #        #$("#profile_home_container").css "width", "1320px"
 #        currentView = new Mywebroom.Views.PhotosLargeView({model:currentGridItem})
 #        $("#profile_home_wrapper").append(currentView.el)
 #        currentView.render()
 #  else
 #    if currentGridItem
 #      #launch new view. profile_drawer needs to expand
 #      $("#profile_drawer").css "width", "1320px"
 #      #$("#profile_home_container").css "width", "1320px"
 #      currentView = new Mywebroom.Views.ActivityItemLargeView({model:currentGridItem})
 #      $("#profile_home_wrapper").append(currentView.el)
 #      currentView.render()
 # showSocialBarView:->
 #  console.log("showSocialBarView function runs")
 # closeSocialBarView:->
 #  console.log("closeSocialBarView functio runs")
 closeProfileView: ->
 	this.remove()