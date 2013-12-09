#ProfileFriendsCollection
class Mywebroom.Collections.IndexFriendByUserIdByLimitByOffsetCollection extends Backbone.Collection

  initialize: (models, options) ->

    @userId = options.userId
    @limit =  options.limit
    @offset = options.offset


  url: ->
    '/friends/json/index_friend_by_user_id_by_limit_by_offset/' + @userId + '/' + @limit + '/' + @offset + '.json'
