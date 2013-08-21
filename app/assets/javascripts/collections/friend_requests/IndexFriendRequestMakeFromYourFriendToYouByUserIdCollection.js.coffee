#Friend Requests Collection
class Mywebroom.Collections.IndexFriendRequestMakeFromYourFriendToYouByUserIdCollection extends Backbone.Collection

  url:(userId) ->
    '/friend_requests/json/index_friend_request_make_from_your_friend_to_you_by_user_id/'+userId+'.json'

