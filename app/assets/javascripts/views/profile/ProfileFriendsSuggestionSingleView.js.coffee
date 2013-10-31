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
    #Key Request. 
    Mywebroom.Helpers.RequestKey(@model.get('user_id'))
    
    #Rerender view with request sent info. 
    #Key Requested Button Template.
    @template = JST['profile/ProfileFriendsSuggestionSingleRequestedTemplate']
    @render() 
