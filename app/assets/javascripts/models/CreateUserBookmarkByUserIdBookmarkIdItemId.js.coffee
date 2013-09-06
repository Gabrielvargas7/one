class Mywebroom.Models.CreateUserBookmarkByUserIdBookmarkIdItemId extends Backbone.Model
	
	@userId
	@bookmarkId
	@itemId
	defaults:
		position:3
		
	url:->
		"/users_bookmarks/json/create_user_bookmark_by_user_id_and_bookmark_id_and_item_id/"+@userId+'/'+@bookmarkId+'/'+@itemId+'.json'