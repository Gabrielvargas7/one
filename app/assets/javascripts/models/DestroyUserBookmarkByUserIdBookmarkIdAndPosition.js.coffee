class Mywebroom.Models.DestroyUserBookmarkByUserIdBookmarkIdAndPosition extends Backbone.Model
	@userId
	@bookmarkId
	@position
	url:->
		'/users_bookmarks/json/destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position/'+this.get('userId')+'/'+this.get('bookmarkId')+'/'+this.get('position')+'.json'