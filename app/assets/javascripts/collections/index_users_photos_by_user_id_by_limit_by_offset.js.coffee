class Mywebroom.Collections.index_users_photos_by_user_id_by_limit_by_offset extends Backbone.Collection
	url:'/users_photos/json/index_users_photos_by_user_id_by_limit_by_offset/:user_id/'+@limit+'/'+@offset+'.json'
	model:Mywebroom.Models.ProfilePhotos