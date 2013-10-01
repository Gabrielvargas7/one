#/friend_requests/json/destroy_friend_request_by_user_id_and_user_id_requested/:user_id/:user_id_requested
class Mywebroom.Models.DestroyFriendRequestByUserIdAndUserIdRequestedModel extends Backbone.Model
	url:(userId,userIdRequested)->
		'/friend_requests/json/destroy_friend_request_by_user_id_and_user_id_requested/'+userId+'/'+userIdRequested+'.json'
	destroyUserFriendRequest:->
		jQuery.ajax
			'url':this.get('url')
			'type':'DELETE'
