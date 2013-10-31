#/friend_requests/json/show_friend_request_by_user_id_user_id_requested/:user_id/:user_id_requested
class Mywebroom.Collections.ShowFriendRequestByUserIdAndUserIdRequestedCollection extends Backbone.Collection
  url:(userId,userIdRequested) ->
     '/friend_requests/json/show_friend_request_by_user_id_user_id_requested/'+userId+'/'+userIdRequested+'.json'
