class Mywebroom.Views.ProfileFriendsSuggestionSingleView extends Backbone.View
  
  tagName:'tr'
  
  className:'profile_friends_suggestion_single'
  
  template: JST['profile/ProfileFriendsSuggestionSingleTemplate']
  
  events:
    'click .profile_request_key_button':'requestKey'
  
  initialize: ->
    #Check if this user's key has been requested. If so, set template to key Requested. 
    hasRequested = Mywebroom.Helpers.IsThisMyFriendRequest(@model.get('user_id'))
    if hasRequested
      @template = JST['profile/ProfileFriendsSuggestionSingleRequestedTemplate']
    
  render: ->
    $(@el).html(@template(model:@model))
  
  requestKey:(event)->
    console.log 'please can i be your friend'
    requestModel = new Mywebroom.Models.CreateFriendRequestByUserIdAndUserIdRequestedModel()
    requestModel.set 'userId', Mywebroom.State.get("signInUser").get("id")
    requestModel.set 'userIdRequested', @model.get('user_id')
    requestModel.save {},
    
    success: (model, response)->
      console.log('post requestKey SUCCESS:')
      console.log(response)
    
    error: (model, response)->
      console.log('post requestKey FAIL:')
      console.log(response)
    
    #Rerender view with request sent info. 
    #Key Requested Button Template.
    @template = JST['profile/ProfileFriendsSuggestionSingleRequestedTemplate']
    @render() 
