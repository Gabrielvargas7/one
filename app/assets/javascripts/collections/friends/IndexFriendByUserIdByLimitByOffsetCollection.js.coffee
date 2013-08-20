class Mywebroom.Collections.IndexFriendByUserIdByLimitByOffsetCollection extends Backbone.Collection

  url:(userId,limit,offset) ->
    '/friends/json/index_friend_by_user_id_by_limit_by_offset/'+userId+'/'+limit+'/'+offset+'.json'

