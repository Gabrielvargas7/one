class Mywebroom.Views.ProfileKeyRequestsView extends Backbone.View
 # className: 'profileHome_activity'
 # template: JST['profile/profileHomeGrid']
 # initialize: ->
 className:'profile_key_requests'
 template:JST['profile/ProfileKeyRequests']
 initialize: ->
 	@friendsSuggestionsCollection = new Mywebroom.Collections.IndexFriendsSuggestionByUserIdByLimitByOffsetCollection()
 	@keyRequestsCollection = new Mywebroom.Collections.IndexFriendRequestMakeFromYourFriendToYouByUserIdCollection()
 	@keyRequestsCollection.fetch
 	  url: @keyRequestsCollection.url @model.get('user_id')
 	  async:false
 	  success: (response)->
 	   console.log("KeyRequestsCollection Fetched Successfully")
 	   console.log(response)
 	@friendsSuggestionsCollection.fetch
      url:@friendsSuggestionsCollection.url @model.get('user_id'), 6, 0
      reset:true
      async:false
      success: (response)->
       console.log("friendsSuggestionsCollection Fetched Successfully")
       console.log(response)
    @friendsSuggestionsView = new Mywebroom.Views.ProfileFriendsSuggestionSingleView({model:@model}) 
 render: ->
 	$(@el).html(@template)
 	@keyRequestsCollection.forEach(@keyRequestAddView,this)
 	@showSuggestedFriends()
 	this
  	
 keyRequestAddView: (keyRequest) ->
 	keyRequestSingleView = new Mywebroom.Views.ProfileKeyRequestSingleView({model:keyRequest})
 	$('#profile_key_request_list').append(keyRequestSingleView.$el)
 	keyRequestSingleView.render()
 	console.log(@.el)
 showSuggestedFriends: ->
 	@friendsSuggestionsCollection.forEach(@friendsSuggestionAddView, this)
 friendsSuggestionAddView: (friendSuggestion) ->
 	friendSuggestionSingleView = new Mywebroom.Views.ProfileFriendsSuggestionSingleView({model:friendSuggestion})
 	$('#profile_suggested_friends_list').append(friendSuggestionSingleView.$el)
 	friendSuggestionSingleView.render()