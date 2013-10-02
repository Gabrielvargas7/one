class Mywebroom.Views.ProfileFriendsSingleView extends Backbone.View
	className:'profile_friend media'
	template: JST['profile/ProfileFriendsSingleTemplate']
	events:
		'click .profile_unfriend':'unfriendConfirm'
	render: ->
		$(@el).html(@template(model:@model,PUBLIC_FLAG:Mywebroom.State.get('roomState')))
	unfriendConfirm:(event)->
		event.stopPropagation()
		modalHTML = JST['profile/ProfileConfirmUnfriendModal'](model:@model)
		$(@el).append(modalHTML)
		$('#myModal').modal(backdrop:false)
		that = this
		#NOTE: This .on is jQuery NOT Backbone.on. 
		$('.profile_unfriend_confirm_button').on('click',that,@unfriendFriend)
		#Destroy the modal instead of hide it, since we have changing data inside it. (model name)
		$("#myModal").on "hidden", ->
			$('#myModal').remove()

	unfriendFriend:(event)->
		deleteFriendModel = new Mywebroom.Models.DestroyFriendByUserIdAndUserIdFriendModel()
		helper = new Mywebroom.Helpers.ItemHelper()
		userId = helper.getUserId()
		deleteFriendModel.set 'url' , deleteFriendModel.url(userId,event.data.model.get('user_id'))
		deleteFriendModel.destroyUserFriend()
		event.data.trigger('Profile:friendRemoved')
		#event.data.remove()