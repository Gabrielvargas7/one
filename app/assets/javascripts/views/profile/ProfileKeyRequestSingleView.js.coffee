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
			  #Need to re-render request screen and suggestions screen. 
			error: (model, response)->
			  console.log('post AcceptKeyRequest FAIL:')
			  console.log(response)
		#Trigger event to re-render KeyRequests and Suggested Friends. 
	denyKeyRequest:(event)->
		console.log 'DENIIIIIIED!'
		denyKeyRequestModel = new Mywebroom.Models.DestroyFriendRequestByUserIdAndUserIdRequestedModel()
		debugger
		denyKeyRequestModel.set('url', denyKeyRequestModel.url(@userId.getUserId(),this.model.get('user_id')))
		denyKeyRequestModel.destroyUserFriendRequest()