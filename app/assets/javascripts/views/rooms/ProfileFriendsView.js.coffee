class Mywebroom.Views.ProfileFriendsView extends Backbone.View
 className:'profile_friend media'
 #template: JST['profile/ProfileFriends']
 initialize: ->
  @friendsCollection = new Mywebroom.Collections.IndexFriendByUserIdByLimitByOffsetCollection()
 # Fetch friends data for Profile Friends
  @friendsCollection.fetch
    url:@friendsCollection.url @model.get('user_id'), 6, 0
    async:false
    success: (response)->
     console.log("FriendsCollection Fetched Successfully")
     console.log(response)
 render: ->
  $(@el).html("<p>Friends View woowoo</p>")
  @friendsCollection.forEach(@friendsAddView,this)
  this
 	
 friendsAddView: (friend) ->
  friendView = new Mywebroom.Views.ProfileFriendsSingleView({model:friend})
  $(@el).append(friendView.el)
  friendView.render()