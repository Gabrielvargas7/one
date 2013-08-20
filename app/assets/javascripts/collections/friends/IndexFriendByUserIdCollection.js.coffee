class Mywebroom.Collections.IndexFriendByUserIdCollection extends Backbone.Collection

  url:(userId) ->
    '/friends/json/index_friend_by_user_id/'+userId+'.json'


