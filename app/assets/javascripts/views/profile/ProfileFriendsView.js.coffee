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
  this.listenTo(@friendsCollection,'remove',@render)
 render: ->
  tableHeaderHTML = JST['profile/ProfileGridTableHeader'](headerName:"Friends ("+@friendsCollection.length+")")
  $(@el).html(tableHeaderHTML)
  if @friendsCollection.length is 0
    @template = JST['profile/ProfileNoFriendsTemplate']
    $(@el).append @template()
  else
    @friendsCollection.forEach(@friendsAddView,this)
  this
 	
 friendsAddView: (friend) ->
  friendView = new Mywebroom.Views.ProfileFriendsSingleView({model:friend,PUBLIC_FLAG:@model.get('FLAG_PROFILE')})
  that = this
  friendView.on('Profile:friendRemoved',(->
    @friendsCollection.remove(friendView.model)),that)
  $(@el).append(friendView.el)
  friendView.render()