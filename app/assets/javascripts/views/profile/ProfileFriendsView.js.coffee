class Mywebroom.Views.ProfileFriendsView extends Backbone.View
 className:'profile_friends_view media'
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
  tableHeaderHTML = JST['profile/ProfileGridTableHeader'](headerName:"Friends ("+@friendsCollection.length+")")
  $(@el).html(tableHeaderHTML)
  @friendsCollection.forEach(@friendsAddView,this)
  this
 	
 friendsAddView: (friend) ->
  friendView = new Mywebroom.Views.ProfileFriendsSingleView({model:friend})
  $(@el).append(friendView.el)
  friendView.render()