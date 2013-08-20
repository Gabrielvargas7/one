#Friends Collection
#/friends/json/index_friend_by_user_id_by_limit_by_offset/:user_id/:limit/:offset

class Mywebroom.Collections.Index_Friend_By_User_Id_By_Limit_By_Offset extends Backbone.Collection
	model:Mywebroom.Models.ProfileFriends
	url: (userID,limit,offset) ->
		'/friends/json/index_friend_by_user_id_by_limit_by_offset/'+userID+'/'+limit+'/'+offset+'.json'