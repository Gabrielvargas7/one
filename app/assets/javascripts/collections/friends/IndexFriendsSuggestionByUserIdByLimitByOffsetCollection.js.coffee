class Mywebroom.Collections.IndexFriendsSuggestionByUserIdByLimitByOffsetCollection extends Backbone.Collection

  url:(userId,limit,offset) ->
    '/friends/json/index_friends_suggestion_by_user_id_by_limit_by_offset/'+userId+'/'+limit+'/'+offset+'.json'

