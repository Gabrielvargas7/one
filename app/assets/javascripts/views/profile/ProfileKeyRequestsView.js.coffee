class Mywebroom.Views.ProfileKeyRequestsView extends Backbone.View
 className:'profile_key_requests'
 template:JST['profile/ProfileKeyRequestsTemplate']
 
 initialize: ->
  @getFriendsSuggestionCollection()
  @getKeyRequestsCollection()
  @friendsSuggestionsView = new Mywebroom.Views.ProfileFriendsSuggestionSingleView({model:@model}) 
 
 render: ->
  $(@el).html(@template)
  if @keyRequestsCollection.length is 0
    $('#profile_key_request_list tbody').append '<p style="color:black"> You have no key requests!</p>'
  else
    @keyRequestsCollection.forEach(@keyRequestAddView,this)
  @showSuggestedFriends()
  this
    
 keyRequestAddView: (keyRequest) ->
  keyRequestSingleView = new Mywebroom.Views.ProfileKeyRequestSingleView({model:keyRequest})
  $('#profile_key_request_list').append(keyRequestSingleView.$el)
  keyRequestSingleView.render()
  keyRequestSingleView.on('ProfileKeyRequest:Deny',@removeKeyRequest,this)
 
 #Friend Suggestions Functions
 showSuggestedFriends: ->
  @friendsSuggestionsCollection.forEach(@friendsSuggestionAddView, this)
 
 friendsSuggestionAddView: (friendSuggestion) ->
  friendSuggestionSingleView = new Mywebroom.Views.ProfileFriendsSuggestionSingleView({model:friendSuggestion})
  $('#profile_suggested_friends_list').append(friendSuggestionSingleView.$el)
  friendSuggestionSingleView.render()
 
 #Remove key request and re-render. Called when user denies a key request.
 removeKeyRequest:(modelToRemove)->
  debugger
  @keyRequestsCollection.remove(modelToRemove)
  this.render()

 #Fetch collection data
 getKeyRequestsCollection:()->
  @keyRequestsCollection = new Mywebroom.Collections.IndexFriendRequestMakeFromYourFriendToYouByUserIdCollection()
  @keyRequestsCollection.fetch
    url: @keyRequestsCollection.url @model.get('user_id')
    async:false
    success: (response)->
     console.log("KeyRequestsCollection Fetched Successfully")
     console.log(response)
 
 getFriendsSuggestionCollection:()->
  @friendsSuggestionsCollection = new Mywebroom.Collections.IndexFriendsSuggestionByUserIdByLimitByOffsetCollection()
  @friendsSuggestionsCollection.fetch
      url:@friendsSuggestionsCollection.url @model.get('user_id'), 6, 0
      reset:true
      async:false
      success: (response)->
       console.log("friendsSuggestionsCollection Fetched Successfully")
       console.log(response)