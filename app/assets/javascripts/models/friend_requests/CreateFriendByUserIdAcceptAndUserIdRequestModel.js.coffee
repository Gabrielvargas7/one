#/friends/json/create_friend_by_user_id_accept_and_user_id_request/:user_id/:user_id_request
class Mywebroom.Models.CreateFriendByUserIdAcceptAndUserIdRequestModel extends Backbone.Model
	@userIdAccept
	@userIdRequest
	url:(userIdAccept,userIdRequest)->
		'/friends/json/create_friend_by_user_id_accept_and_user_id_request/'+this.get('userIdAccept')+'/'+this.get('userIdRequest')+'.json'
