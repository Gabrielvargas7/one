class Mywebroom.Views.ProfileKeyRequestsView extends Backbone.View
	# className: 'profileHome_activity'
	# template: JST['profile/profileHomeGrid']
	# initialize: ->
	className:'profile_key_requests'
	template:JST['profile/ProfileKeyRequests']
	render: ->
	 	$(@el).html(@template(collection:@collection))