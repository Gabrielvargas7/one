class Mywebroom.Views.ProfileHomeView extends Backbone.View
 className: 'user_profile'
 template: JST['profile/profileDraft']
 events:
 	'click #Profile-Photos':'showProfilePhotos',
 	'click #Profile-Friends':'showProfileFriends',
 	'click #Profile-Home':'showHomeGrid',
 	'click #Profile-Close-Button':'closeProfileView'
 	'click #Profile-Collapse-Button':'collapseProfileView'
 initialize: ->
 	@activityCollection=@options.activityCollection
 	@photosCollection=@options.photosCollection

 	@photosView = new Mywebroom.Views.ProfilePhotosView({collection:@photosCollection})
 	@activityView = new Mywebroom.Views.ProfileActivityView({collection:@activityCollection})
 	#@activityCollection.on('reset', @render, this)
   #@collection.on('reset',@render,this)

 render: ->
   #attribute = this.model.toJSON()
   #console.log("ProfileHomeView model toJSON: "+attribute)
   $(@el).html(@template(user_info:@model))     #pass variables into template.
   @showHomeGrid()
   this
 showProfilePhotos: ->
 	#initialize new Profile Photos view
 	$('#profileHome_bottom').html(@photosView.render().el)
 showProfileFriends: ->
 	photosView = new Mywebroom.Views.ProfilePhotosView({model:@model})
 	$('#profileHome_bottom').html(photosView.render().el)
 	#initalize new Profile Friends model. 
 showHomeGrid: ->
 	console.log("ShowHomeGrid runs")
 	#homeGridtemplate= JST['profile/profileHomeGrid']
 	$('#profileHome_bottom').html(@activityView.el)
 	@activityView.render()
 collapseProfileView: ->
 	#If view is open, close it, else reverse.
 	#Sara Note- this is odd looking Coffeescript. I don't see any 
 	#	documentation that elses need to be indented, but that appears to be the case here.
 	if $("#profileHome_container").css("visibility") is "hidden"
    	$("#profileHome_container").css "visibility", "visible"
  		else
    		$("#profileHome_container").css "visibility", "hidden"
 	#Adjust min height of profile-sidebar to browser height?
 	console.log "hi"

 closeProfileView: ->
 	this.remove()