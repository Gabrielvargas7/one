class Mywebroom.Views.ProfileHomeView extends Backbone.View
 className: 'user_profile'
 template: JST['profile/profileHome']
 events:
 	'click #profile_photos':'showProfilePhotos',
 	'click #profile_friends':'showProfileFriends',
 	'click #profile_key_requests':'showProfileKeyRequests',
 	'click #profile_home':'showHomeGrid',
 	'click #Profile-Close-Button':'closeProfileView'
 	'click #Profile-Collapse-Button':'collapseProfileView'
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
 	$('#profileHome_bottom').html(@photosView.render().el)
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
 	console.log("One day I'll show friend suggestions!")
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

 closeProfileView: ->
 	this.remove()