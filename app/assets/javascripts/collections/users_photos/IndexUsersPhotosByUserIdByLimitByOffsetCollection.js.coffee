#Profile Photos Collection
class Mywebroom.Collections.IndexUsersPhotosByUserIdByLimitByOffsetCollection extends Backbone.Collection

  url:(userId,limit,offset) ->
    '/users_photos/json/index_users_photos_by_user_id_by_limit_by_offset/'+userId+'/'+limit+'/'+offset+'.json'


