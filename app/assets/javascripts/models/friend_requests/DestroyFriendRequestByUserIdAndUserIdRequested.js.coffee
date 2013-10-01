#/friend_requests/json/destroy_friend_request_by_user_id_and_user_id_that_make_request/:user_id/:user_id_that_make_request
class Mywebroom.Models.DestroyFriendRequestByUserIdAndUserIdRequestedModel extends Backbone.Model
	url:(userId,userIdRequested)->
		'/friend_requests/json/destroy_friend_request_by_user_id_and_user_id_that_make_request/'+userId+'/'+userIdRequested+'.json'
	destroyUserFriendRequest:->
		jQuery.ajax
			'url':this.get('url')
			'type':'DELETE'
