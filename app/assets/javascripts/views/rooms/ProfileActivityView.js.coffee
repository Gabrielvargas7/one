class Mywebroom.Views.ProfileActivityView extends Backbone.View
	className: 'profileHome_activity'
	template: JST['profile/profileHomeGrid']
	initialize: ->
		
	render: ->
		$(@el).html(@template(activity:@collection))
		#Should template iterate over collection 
		#	or should a separate grid item view be created?