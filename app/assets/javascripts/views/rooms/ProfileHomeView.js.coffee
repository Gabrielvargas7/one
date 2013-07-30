class Mywebroom.Views.ProfileHomeView extends Backbone.View
 className: 'user_profile'
 template: JST['profile/profileHome']
 events:
 	'click #Profile-Photos':'showProfilePhotos',
 	'click #Profile-Friends':'showProfileFriends',
 	'click #Profile-Home':'showHomeGrid',
 	'click #Profile-Close-Button':'closeProfileView'
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
 	console.log("showProfileFriends function runs")
 	photosView = new Mywebroom.Views.ProfilePhotosView({model:@model})
 	$('#profileHome_bottom').html(photosView.render().el)
 	#initalize new Profile Friends model. 
 showHomeGrid: ->
 	console.log('showHomeGrid function runs')
 	$('#profileHome_bottom').html('<p>Need to show INS grid here</p>')
 closeProfileView: ->
 	this.remove()