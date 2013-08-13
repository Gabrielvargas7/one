#Friends Collection
#index_friend_by_user_id_by_limit_by_offset/:user_id/:limit/:offset

class Mywebroom.Collections.Index_Friend_By_User_Id_By_Limit_By_Offset extends Backbone.Collection
	model:Mywebroom.Models.ProfileFriends
	user_id:0
	limit:10
	offset:0
	#id and limit and offset should be set on fetch call
	url: ->
		'/friends/json/index_friend_by_user_id_by_limit_by_offset/'+@user_id+'/'+@limit+'/'+@offset+'.json'