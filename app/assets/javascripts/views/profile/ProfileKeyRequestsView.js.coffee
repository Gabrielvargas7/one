class Mywebroom.Views.ProfileKeyRequestsView extends Backbone.View
 className:'profile_key_requests'
 template:JST['profile/ProfileKeyRequestsTemplate']

 initialize: ->
  @friendsFetchLimit = 6
  @friendsOffset = 0

  @getFriendsSuggestionCollection()
  @getKeyRequestsCollection()
  @friendsSuggestionsView = new Mywebroom.Views.ProfileFriendsSuggestionSingleView({model:@model})

 render: ->
  $(@el).html(@template)
  if @keyRequestsCollection.length is 0
    $('#profile_key_request_list tbody').append '<p style="color:black;padding: 1em;
text-align: center;"> You have no key requests!</p>'
    $('.profile_table_innerDiv.profile_suggested_friends').css "height","500px"
  else
    @keyRequestsCollection.forEach(@keyRequestAddView,this)
  @showSuggestedFriends()
  #Set Scroll Event for Paginate Suggested Friends
  if @friendsSuggestionsCollection.length > 0
    that = this
    if Mywebroom.State.get("roomState") is "SELF"
      @$('.profile_table_innerDiv.profile_suggested_friends').off('scroll').on('scroll',that,(event)->
        if $(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight-100
          event.data.paginateSuggestedFriends(event)
      )

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
  @keyRequestsCollection.remove(modelToRemove)
  this.render()

 #Fetch collection data
 getKeyRequestsCollection:()->
  @keyRequestsCollection = new Mywebroom.Collections.IndexFriendRequestMakeFromYourFriendToYouByUserIdCollection()
  @keyRequestsCollection.fetch
    url: @keyRequestsCollection.url @model.get('user_id')
    async:false
    success: (response)->
      #console.log("KeyRequestsCollection Fetched Successfully")
      #console.log(response)

 getFriendsSuggestionCollection:()->
  @friendsSuggestionsCollection = new Mywebroom.Collections.IndexFriendsSuggestionByUserIdByLimitByOffsetCollection()
  @friendsSuggestionsCollection.fetch
      url:@friendsSuggestionsCollection.url @model.get('user_id'), @friendsFetchLimit, @friendsOffset
      reset:true
      async:false
      success: (response)->
        #console.log("friendsSuggestionsCollection Fetched Successfully")
        #console.log(response)

 paginateSuggestedFriends:(event)->
    event.preventDefault()
    event.stopPropagation()

    #Turn off event so multiple scrolls don't cause multiple fetches. (We'll turn it back on at the end of the function)
    @$('.profile_table_innerDiv.profile_suggested_friends').off('scroll')

    #1 Increment Offset
    event.data.friendsOffset += event.data.friendsFetchLimit;

    #2. Grab more Friends
    tempCollection = new Mywebroom.Collections.IndexFriendsSuggestionByUserIdByLimitByOffsetCollection()
    tempCollection.fetch
        url:tempCollection.url event.data.model.get('user_id'), event.data.friendsFetchLimit, event.data.friendsOffset
        reset:true
        async:false
        success: (response)->
          #console.log("friendsSuggestionsCollection Fetched Successfully")
          #console.log(response)

    #3. Render the view
    tempCollection.forEach(event.data.friendsSuggestionAddView)
    #event.data.friendsSuggestionsCollection.add(tempCollection.toJSON())

    #4. If nothing fetched, turn off the scroll event.
    if tempCollection.models.length < event.data.friendsFetchLimit
      @$('.profile_table_innerDiv.profile_suggested_friends').off('scroll')
    else
      that = this
      $('.profile_table_innerDiv.profile_suggested_friends').off('scroll').on('scroll',that,(event)->
        if $(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight-100
          event.data.paginateSuggestedFriends(event)
      )
