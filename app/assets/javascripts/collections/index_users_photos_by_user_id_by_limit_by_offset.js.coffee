#Profile Photos Collection
class Mywebroom.Collections.index_users_photos_by_user_id_by_limit_by_offset extends Backbone.Collection
	model:Mywebroom.Models.ProfilePhotos
	#This is the urlRoot. The arguments to fetch need to be passed in a url option from the fetch call
	urlRoot:'/users_photos/json/index_users_photos_by_user_id_by_limit_by_offset/'