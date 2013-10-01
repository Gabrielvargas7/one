class Mywebroom.Views.ProfileKeyRequestSingleView extends Backbone.View
	template:JST['profile/ProfileRequestSingleTemplate']
	tagName:'tr'
	className:'profile_single_request'
	events:
		'click .profile_request_accept':'acceptKeyRequest'
	render: ->
		$(@el).html(@template(model:@model))
	acceptKeyRequest:(event)->
		event.stopPropagation()
		acceptKeyRequestModel = new Mywebroom.Models.CreateFriendByUserIdAcceptAndUserIdRequestModel()
		userId = new Mywebroom.Helpers.ItemHelper()
		acceptKeyRequestModel.set
			'userIdAccept':userId.getUserId()
			'userIdRequest':this.model.get('user_id')
		acceptKeyRequestModel.save {},
			success: (model, response)->
			  console.log('post AcceptKeyRequest SUCCESS:')
			  console.log(response)
			error: (model, response)->
			  console.log('post AcceptKeyRequest FAIL:')
			  console.log(response)