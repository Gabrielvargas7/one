#/friend_requests/json/create_friend_request_by_user_id_and_user_id_requested/:user_id/:user_id_requested
class Mywebroom.Models.CreateFriendRequestByUserIdAndUserIdRequestedModel extends Backbone.Model
  @userId
  @userIdRequested
  url:(userId,userIdRequested)->
    '/friend_requests/json/create_friend_request_by_user_id_and_user_id_requested/' + this.get('userId')+'/' + this.get('userIdRequested') + '.json'
