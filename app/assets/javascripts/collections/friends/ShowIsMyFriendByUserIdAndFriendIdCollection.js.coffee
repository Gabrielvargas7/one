class Mywebroom.Collections.ShowIsMyFriendByUserIdAndFriendIdCollection extends Backbone.Collection

  url:(userId,friendId) ->
     '/friends/json/show_is_my_friend_by_user_id_and_friend_id/'+userId+'/'+friendId+'.json'
