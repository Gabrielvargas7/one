#Friend Requests Collection
#  /friend_requests/json/index_friend_request_make_from_your_friend_to_you_by_user_id/:user_id
class Mywebroom.Collections.Index_Friend_Request_Make_From_Your_Friend_To_You_By_User_Id extends Backbone.Collection
	url: (userID)->
		'/friend_requests/json/index_friend_request_make_from_your_friend_to_you_by_user_id/'+userID+'.json'