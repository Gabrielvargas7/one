class Mywebroom.Views.ProfileKeyRequestSingleView extends Backbone.View
  template:JST['profile/ProfileRequestSingleTemplate']
  tagName:'tr'
  className:'profile_single_request'
  events:
    'click .profile_request_accept':'acceptKeyRequest'
    'click .profile_request_deny':'denyKeyRequest'

  initialize:->
    @userId = new Mywebroom.Helpers.ItemHelper()

  render: ->
    $(@el).html(@template(model:@model))

  acceptKeyRequest:(event)->
    event.stopPropagation()
    acceptKeyRequestModel = new Mywebroom.Models.CreateFriendByUserIdAcceptAndUserIdRequestModel()
    acceptKeyRequestModel.set
      'userIdAccept':@userId.getUserId()
      'userIdRequest':this.model.get('user_id')
    acceptKeyRequestModel.save {},
      success: (model, response)->
        console.log('post AcceptKeyRequest SUCCESS:')
        console.log(response) 
      error: (model, response)->
        console.log('post AcceptKeyRequest FAIL:')
        console.log(response)
    #Rerender the view with view room button.
    @template = JST['profile/ProfileRequestSingleAcceptedTemplate']
    this.render()
    
  denyKeyRequest:(event)->
    denyKeyRequestModel = new Mywebroom.Models.DestroyFriendRequestByUserIdAndUserIdRequestedModel()
    this.trigger('ProfileKeyRequest:Deny',@model)
    denyKeyRequestModel.set('url', denyKeyRequestModel.url(@userId.getUserId(),this.model.get('user_id')))
    denyKeyRequestModel.destroyUserFriendRequest()