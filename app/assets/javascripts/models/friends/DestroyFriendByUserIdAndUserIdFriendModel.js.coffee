#Used to Delete a user bookmark. Just set the url to delete. Then call destroyUserBookmark. 
class Mywebroom.Models.DestroyFriendByUserIdAndUserIdFriendModel extends Backbone.Model
  @userId
  @friendUserId
  url:(userId,friendUserId)->
    '/friends/json/destroy_friend_by_user_id_and_user_id_friend/'+userId+'/'+friendUserId+'.json'
  destroyUserFriend:->
    jQuery.ajax
      'url':this.get('url')
      'type':'DELETE'