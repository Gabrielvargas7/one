#Profile Photos Collection
class Mywebroom.Collections.index_users_photos_by_user_id_by_limit_by_offset extends Backbone.Collection
	model:Mywebroom.Models.ProfilePhotos
	url: (userID,limit,offset) ->
		'/users_photos/json/index_users_photos_by_user_id_by_limit_by_offset/'+userID+'/'+limit+'/'+offset+'.json'
