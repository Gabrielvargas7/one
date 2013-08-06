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
 	@photosView = new Mywebroom.Views.ProfilePhotosView({model:@model})
   #@collection.on('reset',@render,this)

 render: ->
   #attribute = this.model.toJSON()
   #console.log("ProfileHomeView model toJSON: "+attribute)
   $(@el).html(@template(user_info:@model))     #pass variables into template.
   this
 showProfilePhotos: ->
 	#initialize new Profile Photos view
 	$('#profileHome_bottom').html(@photosView.render().el)
 showProfileFriends: ->
 	photosView = new Mywebroom.Views.ProfilePhotosView({model:@model})
 	$('#profileHome_bottom').html(photosView.render().el)
 	#initalize new Profile Friends model. 
 showHomeGrid: ->
 	homeGridtemplate= JST['profile/profileHomeGrid']
 	$('#profileHome_bottom').html(homeGridtemplate)
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